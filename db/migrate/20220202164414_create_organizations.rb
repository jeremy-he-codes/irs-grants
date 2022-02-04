class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false, index: true
      t.string :ein
      t.boolean :is_filer, default: false
      t.boolean :is_recipient, default: false

      t.timestamps
    end

    add_index :organizations, :ein, unique: true
  end
end
