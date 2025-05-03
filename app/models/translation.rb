# == Schema Information
#
# Table name: translations
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :bigint           not null
#  message_id  :bigint           not null
#
# Indexes
#
#  index_translations_on_language_id                 (language_id)
#  index_translations_on_message_id                  (message_id)
#  index_translations_on_message_id_and_language_id  (message_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (message_id => messages.id)
#
class Translation < ApplicationRecord
  belongs_to :message
  belongs_to :language

  validates :content, presence: true
  validates :language_id, uniqueness: {scope: :message_id, message: "translation already exists for this language"}
end
