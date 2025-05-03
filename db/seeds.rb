# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Import languages from JSON file
require "json"

languages_json = File.read(Rails.root.join("lib", "assets", "languages.json"))
languages_data = JSON.parse(languages_json)

languages_data.each do |language_data|
  Language.find_or_create_by!(name: language_data["name"]) do |language|
    language.name_english = language_data["name_in_english"]
    language.icon = language_data["icon"]
    language.you = language_data["you"]
  end
end

puts "#{Language.count} languages created!"
