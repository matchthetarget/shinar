class CreateTranslations < ActiveRecord::Migration[8.0]
  def change
    create_table :translations do |t|
      t.references :message, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
    
    add_index :translations, [:message_id, :language_id], unique: true
  end
end
