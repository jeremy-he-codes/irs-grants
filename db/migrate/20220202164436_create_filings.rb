class CreateFilings < ActiveRecord::Migration[6.1]
  def change
    create_table :filings do |t|
      t.integer :filer_id, index: true
      t.integer :tax_year, null: false, index: true
      t.datetime :period_begin_date
      t.datetime :period_end_date

      t.timestamps
    end

    add_index :filings, [:filer_id, :tax_year], :unique => true
  end
end
