require 'csv'

class FormsController < ApplicationController
  before_action :authenticate_user!, except: :edit

  def edit
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])

    if !user_signed_in? && !@survey.is_public
      render plain: t('.expired')
    end
  end

  def responses
    set_responses(7, 1000)
  end

  def download
    set_responses(30, 100000)
    data = generate_csv
    filename = "results-#{(Time.zone.now.in_time_zone('Tokyo')).to_fs(:db)}.csv"
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
      csv << ['', 'Time', 'IP', @survey.questions.map(&:title)].flatten
      @survey_responses.reverse.each.with_index do |survey_response, i|
        csv << [i + 1, survey_response.created_at.to_fs(:db), survey_response.ip, survey_response.answers.map(&:message)].flatten
      end
    end
  end

  def parse_time(value)
    value.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/) ? Time.zone.parse(value) : nil
  rescue => e
    nil
  end
end
