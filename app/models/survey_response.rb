class SurveyResponse < ApplicationRecord
  has_many :answers

  validates :survey_id, presence: true
  validates :ip, presence: true

  scope :search_answers, -> word do
    where('answers.message LIKE ?', "%#{sanitize_sql_like(word)}%").references(:answers)
  end

  class << self
    def duplicate_answers?(ip, answers)
      records = includes(:answers).where('created_at > ?', 10.minute.ago).where(ip: ip)
      found = false

      records.each do |record|
        if record.answers.map(&:message) == answers.map(&:message)
          found = true
          break
        end
      end

      found
    end
  end
end
