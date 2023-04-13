class SurveyResponsesController < ApplicationController
  def create
    survey = Survey.find_by_token(params[:survey_token])

    if DeniedIp.where(ip: request.ip).exists?
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    answers =
        params[:answers].map do |answer|
          Answer.new(question_id: answer[:question_id], message: sanitize_message(answer[:message]))
        end

    if SurveyResponse.duplicate_answers?(request.ip, answers)
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    survey_response = SurveyResponse.new(survey_id: survey.id)
    survey_response.assign_attributes(tracking_params)

    SurveyResponse.transaction do
      survey_response.save!
      survey_response.answers = answers
    end

    redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
  end

  private

  def sanitize_message(text)
    ApplicationController.helpers.strip_tags(text).gsub(/\r?\n/, "\n").chomp
  end

  def tracking_params
    {ip: request.ip, browser: request.browser, os: request.os, device_type: request.device_type}
  end
end
