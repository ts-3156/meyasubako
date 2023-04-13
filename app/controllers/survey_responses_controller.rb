class SurveyResponsesController < ApplicationController
  def create
    survey = Survey.find_by_token(params[:survey_token])

    if BlockedIp.where(ip: request.ip).exists?
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    answers =
        params[:answers].map do |answer|
          message = ApplicationController.helpers.strip_tags(answer[:message])
          Answer.new(question_id: answer[:question_id], message: message)
        end

    if SurveyResponse.duplicate_answers?(request.ip, answers)
      redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
      return
    end

    survey_response = SurveyResponse.new(survey_id: survey.id, ip: request.ip)

    SurveyResponse.transaction do
      survey_response.save!
      survey_response.answers = answers
    end

    redirect_to form_path(survey_token: survey.survey_token), notice: t('.thanks')
  end
end
