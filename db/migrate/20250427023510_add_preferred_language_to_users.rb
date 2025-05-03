class AddPreferredLanguageToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :preferred_language, null: false, foreign_key: {to_table: :languages}
  end
end
