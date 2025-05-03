class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.string :token, null: false
      t.references :creator, null: false, foreign_key: {to_table: :users}
      t.string :subject, null: false, default: "pending"

      t.timestamps
    end

    add_index :chats, :token, unique: true
  end
end
