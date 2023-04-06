class FormsController < ApplicationController
  before_action :set_survey, only: [:edit, :responses]
  def edit
  end

  def responses
  end

  private

  def set_survey
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])
  end
end
