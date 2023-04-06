class SurveyResponsesController < ApplicationController
  def create
    survey = Survey.find_by_token(params[:survey_token])

    if BlockedIp.where(ip: request.ip).exists?
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    survey_response = SurveyResponse.new(survey_id: survey.id, ip: request.ip)
    params[:answers].each do |message|
      survey_response.answers.build(message: ApplicationController.helpers.strip_tags(message))
    end

    if SurveyResponse.duplicate_record?(survey_response)
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    SurveyResponse.transaction do
      survey_response.save!
    end

    redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
  end
end
