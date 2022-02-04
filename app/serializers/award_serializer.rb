class AwardSerializer < BaseSerializer
  attributes :id, :amount, :grant_purpose, :irc_section
  belongs_to :recipient, serializer: RecipientSerializer
  belongs_to :filing
end
