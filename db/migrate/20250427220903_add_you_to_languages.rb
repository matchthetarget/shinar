class AddYouToLanguages < ActiveRecord::Migration[8.0]
  def change
    add_column :languages, :you, :string
  end
end
