class SurveyResponse < ApplicationRecord
  has_many :answers

  validates :survey_id, presence: true
  validates :ip, presence: true

  scope :search_answers, -> word do
    where('answers.message LIKE ?', "%#{sanitize_sql_like(word)}%").references(:answers)
  end

  class << self
    def duplicate_answers?(survey_id, ip, answers)
      records = includes(:answers).where('created_at > ?', 10.minute.ago).where(survey_id: survey_id, ip: ip)
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

  def save_with_answers!(raw_answers)
    if raw_answers.empty?
      raise EmptyAnswers.new({survey_id:}.inspect)
    end

    answers =
        raw_answers.map do |answer|
          Answer.new(question_id: answer[:question_id], message: answer[:message])
        end

    if self.class.duplicate_answers?(survey_id, ip, answers)
      raise DuplicateAnswers.new({survey_id:, raw_answers:}.inspect)
    end

    if invalid?
      raise ValidationFailed.new({survey_id:, raw_answers:, full_messages: errors.full_messages}.inspect)
    end

    begin
      transaction do
        save!
        self.answers = answers
      end
    rescue => e
      raise SavingFailed.new({survey_id:, raw_answers:, exception: e}.inspect)
    end
  end

  class EmptyAnswers < StandardError; end

  class DuplicateAnswers < StandardError; end

  class SavingFailed < StandardError; end

  class ValidationFailed < StandardError; end
end
