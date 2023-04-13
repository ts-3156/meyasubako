class FormsController < ApplicationController
  def index
    @surveys = Survey.where(is_public: true).order(created_at: :desc).limit(100)
  end

  def edit
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])

    unless @survey
      render 'not_found', status: :not_found
      return
    end

    if !user_signed_in? && !@survey.is_public
      render 'expired'
    end
  end
end
