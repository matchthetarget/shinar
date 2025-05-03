class AddOriginalLanguageToMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :original_language, null: false, foreign_key: {to_table: :languages}
  end
end
