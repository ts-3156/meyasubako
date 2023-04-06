require 'digest/md5'

class Survey < ApplicationRecord
  has_many :questions
  has_many :survey_responses

  validates :title, presence: true
  validates :description, presence: true

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

  def description_html
    # TODO Fix performance issue
    description.gsub(/\r?\n/, '<br>').html_safe
  end
end
