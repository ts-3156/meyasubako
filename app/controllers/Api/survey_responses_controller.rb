module Api
  class SurveyResponsesController < BaseController
    include SurveyResponsesHelper

    def index
      survey = Survey.includes(:questions).find(params[:id])
      render json: {data: json_data(survey)}
    end
  end
end
