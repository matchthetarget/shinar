class AddNameCustomizedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name_customized, :boolean, default: false
  end
end
