class Question < ApplicationRecord
  validates :survey_id, presence: true
  validates :title, presence: true
end
