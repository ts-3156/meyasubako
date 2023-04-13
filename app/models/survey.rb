require 'digest/md5'

class Survey < ApplicationRecord
  has_many :questions
  has_many :survey_responses

  validates :title, presence: true
  validates :description, presence: true

  DEFAULT_QUESTIONS = 10

  before_create do
    if survey_token.blank?
      self.survey_token = Digest::MD5.hexdigest(Time.zone.now.to_i.to_s)
    end
  end

  class << self
    def find_by_token(token)
      find_by(survey_token: token)
    end
  end
end
