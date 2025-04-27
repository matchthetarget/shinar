# == Schema Information
#
# Table name: languages
#
#  id           :bigint           not null, primary key
#  icon         :string           not null
#  name         :string           not null
#  name_english :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_languages_on_name          (name) UNIQUE
#  index_languages_on_name_english  (name_english) UNIQUE
#
class Language < ApplicationRecord
  has_many :translations, dependent: :destroy
  has_many :messages_as_original, class_name: "Message", foreign_key: "original_language_id", dependent: :restrict_with_error
  has_many :users_as_preferred, class_name: "User", foreign_key: "preferred_language_id", dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :icon, presence: true
  validates :name_english, presence: true, uniqueness: true
end
