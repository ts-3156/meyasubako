class SurveyResponsesController < ApplicationController
  def create
    survey = Survey.find_by_token(params[:survey_token])

    if BlockedIp.where(ip: request.ip).exists?
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    SurveyResponse.transaction do
      survey_response = SurveyResponse.create!(survey_id: survey.id, ip: request.ip)
      params[:answers].each do |message|
        survey_response.answers.create!(message: ApplicationController.helpers.strip_tags(message))
      end
    end

    redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
  end
end
