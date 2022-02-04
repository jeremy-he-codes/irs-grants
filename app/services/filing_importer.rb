require 'nokogiri'
require 'open-uri'

class FilingImporter
  class << self
    def import(doc_url)
      data_hash = parse_doc(doc_url)
      save_entries(data_hash)
    end

    private

    def save_entries(data_hash)
      return nil if data_hash.nil?

      ActiveRecord::Base.transaction do
        # FILING, FILERs
        filing_data = data_hash[:ReturnHeader]
        filer_data = filing_data[:Filer]

        ## filer
        filer = Organization.find_by_ein(filer_data[:EIN])
        if filer.present?
          filer.update(is_filer: true)
        else
          filer = Organization.create!(
            ein: filer_data[:EIN],
            name: dig_versatile(filer_data, %i(Name BusinessName), %i(BusinessNameLine1 BusinessNameLine1Txt)),
            is_filer: true
          )
        end

        ## filer address
        address_attrs = extract_address(filer_data)
        if filer.address.present?
          filer.address.update!(address_attrs)
        else
          filer.create_address!(address_attrs)
        end

        ## filing
        filing = filer.filings.create!(
          tax_year: dig_versatile(filing_data, %i(TaxYear TaxYr))&.to_i,
          period_begin_date: (dig_versatile(filing_data, %i(TaxPeriodBeginDt TaxPeriodBeginDate))&.to_date rescue nil),
          period_end_date: (dig_versatile(filing_data, %i(TaxPeriodEndDt TaxPeriodEndDate))&.to_date rescue nil)
        )

        # AWARDs, RECIPIENTs
        awards_list = data_hash.dig(:ReturnData, :IRS990ScheduleI, :RecipientTable)
        return true if awards_list.nil?

        awards_list.each do |award_data|
          # recipient
          ein = dig_versatile(award_data, %i(EINOfRecipient RecipientEIN))
          org_name = dig_versatile(
            award_data,
            %i(RecipientNameBusiness RecipientBusinessName),
            %i(BusinessNameLine1 BusinessNameLine1Txt)
          )

          # Recipient businesses could be EIN-less, i.e. a church
          recipient = ein.present? ? Organization.find_by_ein(ein) : Organization.find_by_name(org_name)
          if recipient.present?
            recipient.update(is_recipient: true)
          else
            recipient = Organization.create!(
              ein: ein,
              name: org_name,
              is_recipient: true
            )
          end

          ## recipient address
          address_attrs = extract_address(award_data)
          if recipient.address.present?
            recipient.address.update!(address_attrs)
          else
            recipient.create_address!(address_attrs)
          end

          ## award
          filing.awards.create!(
            recipient_id: recipient.id,
            amount: dig_versatile(award_data, %i(AmountOfCashGrant CashGrantAmt))&.to_i,
            grant_purpose: dig_versatile(award_data, %i(PurposeOfGrant PurposeOfGrantTxt)),
            irc_section: dig_versatile(award_data, %i(IRCSection IRCSectionDesc))
          )
        end
      end

      true
    rescue => e
      Rails.logger.error(['ENTRY CREATION ERROR', 'Transction rolled back'])
      Rails.logger.error e.message
      Rails.logger.error e.backtrace

      false
    end

    def parse_doc(doc_url)
      remote_file = URI.open(doc_url)
      xml_tree = Nokogiri::XML(remote_file)

      process_xml(xml_tree)
    rescue Nokogiri::XML::SyntaxError
      Rails.logger.error(['FILE CONTENT ERROR', 'Invalid XML syntax'])
      nil
    rescue
      Rails.logger.error(['REMOTE FILE ERROR', 'Could not open'])
      nil
    end

    def process_xml(xml_tree, keep_root = false)
      content_hash = xml_node_to_hash(xml_tree.root)

      return { xml_tree.root.name.to_sym => content_hash } if keep_root
      content_hash
    rescue
      Rails.logger.error(['FILE CONTENT ERROR', 'Could not process'])
      nil
    end

    # Ref: https://gist.github.com/huy/819999
    def xml_node_to_hash(node)
      # If we are at the root of the document, start the hash
      if node.element?
        result_hash = {}
        if node.attributes != {}
          attributes = {}
          node.attributes.keys.each do |key|
            attributes[node.attributes[key].name.to_sym] = node.attributes[key].value
          end
        end
        if node.children.size > 0
          node.children.each do |child|
            result = xml_node_to_hash(child)

            if child.name == "text"
              unless child.next_sibling || child.previous_sibling
                return result unless attributes
                result_hash[child.name.to_sym] = result
              end
            elsif result_hash[child.name.to_sym]

              if result_hash[child.name.to_sym].is_a?(Object::Array)
                 result_hash[child.name.to_sym] << result
              else
                 result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << result
              end
            else
              result_hash[child.name.to_sym] = result
            end
          end
          if attributes
             #add code to remove non-data attributes e.g. xml schema, namespace here
             #if there is a collision then node content supersets attributes
             result_hash = attributes.merge(result_hash)
          end
          return result_hash
        else
          return attributes
        end
      else
        return node.content.to_s
      end
    end

    def extract_address(hash)
      address_data = dig_versatile(hash, %i(USAddress AddressUS))

      {
        address_line1: dig_versatile(address_data, %i(AddressLine1 AddressLine1Txt)),
        city: dig_versatile(address_data, %i(City CityNm)),
        state: dig_versatile(address_data, %i(State StateAbbreviationCd)),
        zip_code: dig_versatile(address_data, %i(ZIPCode ZIPCd)),
      }
    end

    # selectors: [[:USAddress, :AddressUS], [:AddressLine1, :AddressLine1Txt]]
    # strong assumption: there exists only one valid key for a given depth. i.e. h[:USAddress] and h[:AddressUS] can't co-present
    def dig_versatile(hash, *selectors)
      child_hash = hash
      selector_index = 0

      loop do
        has_content = false
        selectors[selector_index].each do |key_variant|
          if child_hash[key_variant].present?
            has_content = true
            child_hash = child_hash[key_variant]
            selector_index += 1
            break
          end
        end

        return nil unless has_content
        if selector_index == selectors.size
          return child_hash
        end
      end
    end
  end
end
