module Api
  class SurveysController < BaseController
    def update
      survey = Survey.find(params[:id])
      survey.update(is_public: parse_boolean(params[:is_public]))
      render json: {id: survey.id, is_public: survey.is_public}
    end

    private

    def parse_boolean(value)
      if value == 'true'
        true
      elsif value == 'false'
        false
      else
        raise
      end
    end
  end
end
