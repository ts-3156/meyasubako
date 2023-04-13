class Answer < ApplicationRecord
  validates :survey_response_id, presence: true
  validates :question_id, presence: true
end
