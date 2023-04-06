require 'digest/md5'

class Survey < ApplicationRecord
  has_many :questions
  has_many :survey_responses

  class << self
    def find_by_token(token)
      find_by(survey_token: token)
    end
  end
end
