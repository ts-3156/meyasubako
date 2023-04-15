class SurveyResponsesController < ApplicationController
  before_action :check_denied_ip
  before_action :check_survey_existence
  before_action :check_survey_expiry

  def create
    survey = Survey.find_by(survey_token: params[:survey_token])
    survey_response = SurveyResponse.new(
        survey_id: survey.id,
        ip: request.ip,
        browser: request.browser,
        os: request.os,
        device_type: request.device_type
    )

    begin
      raw_answers = params[:answers].map { |a| {question_id: a[:question_id], message: a[:message]} }
      survey_response.save_with_answers!(raw_answers)
    rescue => e
      ahoy.track('Creating SurveyResponse failed', exception: e.inspect, backtrace: e.backtrace)
    end

    redirect_to form_path(survey_token: params[:survey_token]), notice: t('.thanks')
  end

  private

  def check_denied_ip
    if DeniedIp.where(ip: request.ip).exists?
      ahoy.track('Validating SurveyResponse failed', reason: 'denied ip')
      redirect_to form_path(survey_token: params[:survey_token]), notice: t('.create.thanks')
    end
  end

  def check_survey_existence
    unless Survey.where(survey_token: params[:survey_token]).exists?
      ahoy.track('Validating SurveyResponse failed', reason: 'invalid survey_token')
      redirect_to forms_path, notice: t('.create.invalid_survey_token')
    end
  end

  def check_survey_expiry
    unless Survey.where(survey_token: params[:survey_token]).where(is_public: true).exists?
      ahoy.track('Validating SurveyResponse failed', reason: 'expired survey')
      redirect_to forms_path, notice: t('.create.invalid_survey_token')
    end
  end
end
