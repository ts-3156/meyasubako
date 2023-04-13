module Api
  class SurveyResponsesController < BaseController
    def index
      survey = Survey.includes(:questions).find(params[:id])
      from_time, to_time = parse_duration(params[:duration])
      limit = parse_limit(params[:limit])

      survey_responses = SurveyResponse.includes(:answers).
          where(survey_id: survey.id).
          where(created_at: from_time..to_time).
          order(created_at: :desc).
          limit(limit)

      if params[:q].present?
        survey_responses = survey_responses.search_answers(params[:q])
      end

      data = survey_responses.map.with_index do |survey_response, i|
        row = {
            number: i + 1,
            time: survey_response.created_at.to_fs(:db),
            ip: survey_response.ip,
        }

        survey_response.answers.each do |answer|
          row["question-#{answer.question_id}"] = answer.message
        end

        row
      end

      render json: {data: data}
    end

    private

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
      else
        100
      end
    end
  end
end
