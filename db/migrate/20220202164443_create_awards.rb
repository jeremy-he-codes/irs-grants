class CreateAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :awards do |t|
      t.references :filing, index: true
      t.integer :recipient_id, index: true

      t.bigint :amount, null: false
      t.string :grant_purpose
      t.string :irc_section, index: true

      t.timestamps
    end
  end
end
