require 'csv'

class FormsController < ApplicationController
  def edit
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])
  end

  def responses
    set_responses(7, 100)
  end

  def download
    set_responses(30, 100000)
    data = generate_csv
    filename = "results-#{(Time.zone.now.in_time_zone('Tokyo')).to_s(:db)}.csv"
    send_data data, filename: filename, type: 'text/csv; charset=utf-8'
  end

  private

  def set_responses(days, limit)
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])
    @days = days
    @limit = limit
    from_time = parse_time(params[:from_time]) || @days.days.ago
    to_time = parse_time(params[:to_time]) || Time.zone.now
    @survey_responses = SurveyResponse.includes(:answers).
        where(survey_id: @survey.id).
        where(created_at: from_time..to_time).
        order(created_at: :desc).
        limit(@limit)
  end

  def generate_csv
    CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      csv << ['', 'Time', @survey.questions.map(&:title)].flatten
      @survey_responses.reverse.each.with_index do |survey_response, i|
        csv << [i + 1, survey_response.created_at.to_s(:db), survey_response.answers.map(&:message)].flatten
      end
    end
  end

  def parse_time(value)
    value.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/) ? Time.zone.parse(value) : nil
  rescue => e
    nil
  end
end
