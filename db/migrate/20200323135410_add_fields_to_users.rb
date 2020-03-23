class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :middle_name, :string
  end
end
