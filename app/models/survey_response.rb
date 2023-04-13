class SurveyResponse < ApplicationRecord
  has_many :answers

  scope :search_answers, -> word do
    where('answers.message LIKE ?', "%#{sanitize_sql_like(word)}%").references(:answers)
  end

  class << self
    def duplicate_record?(new_record)
      records = includes(:answers).where('created_at > ?', 10.minute.ago).where(ip: new_record.ip)
      found = false

      records.each do |record|
        if record.answers.map(&:message) == new_record.answers.map(&:message)
          found = true
          break
        end
      end

      found
    end
  end
end
