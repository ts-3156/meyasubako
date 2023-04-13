class Question < ApplicationRecord
  validates :survey_id, presence: true
end
