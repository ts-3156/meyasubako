class Answer < ApplicationRecord
  validates :survey_response_id, presence: true
  validates :question_id, presence: true

  def message=(value)
    super(ApplicationController.helpers.strip_tags(value).gsub(/\r?\n/, "\n").strip)
  end
end
