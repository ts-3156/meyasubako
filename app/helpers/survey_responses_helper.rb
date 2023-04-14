require 'csv'

module SurveyResponsesHelper
  def json_data(survey)
    survey_responses = fetch_survey_responses(survey)

    survey_responses.map.with_index do |survey_response, i|
      row = {
          number: i + 1,
          time: survey_response.created_at.to_fs(:db),
          ip: survey_response.ip,
          browser: survey_response.browser,
          os: survey_response.os,
          device_type: survey_response.device_type,
      }

      survey_response.answers.each do |answer|
        row["question-#{answer.question_id}"] = answer.message.gsub(/\r?\n/, '<br>')
      end

      row
    end
  end

  def csv_data(survey)
    survey_responses = fetch_survey_responses(survey)

    CSV.generate(headers: true, write_headers: true, force_quotes: true, encoding: 'utf-8') do |csv|
      csv << ['Number', 'Time', 'IP', 'Browser', 'OS', 'DeviceType', survey.questions.map(&:title)].flatten
      survey_responses.each.with_index do |survey_response, i|
        csv << [
            i + 1, survey_response.created_at.to_fs(:db),
            survey_response.ip,
            survey_response.browser,
            survey_response.os,
            survey_response.device_type,
            survey_response.answers.map(&:message)
        ].flatten
      end
    end
  end

  def fetch_survey_responses(survey)
    from_time, to_time = parse_duration(params[:duration])
    limit = parse_limit(params[:limit])
    query = params[:q]

    survey_responses = SurveyResponse.includes(:answers).
        where(survey_id: survey.id).
        where(created_at: from_time..to_time).
        order(created_at: :desc).
        limit(limit)

    if query.present?
      ids = survey_responses.search_answers(query).pluck(:id)
      survey_responses = survey_responses.where(id: ids)
    end

    survey_responses
  end

  def parse_duration(value)
    if value == '7_days'
      [7.days.ago, Time.zone.now]
    elsif value == '30_days'
      [30.days.ago, Time.zone.now]
    else
      [7.days.ago, Time.zone.now]
    end
  end

  def parse_limit(value)
    if value == '10'
      10
    elsif value == '100'
      100
    elsif value == '1000'
      1000
    elsif value == '10000'
      10_000
    elsif value == '100000'
      100_000
    else
      100
    end
  end
end
