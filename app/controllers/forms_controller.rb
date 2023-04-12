class FormsController < ApplicationController
  def index
    @surveys = Survey.where(is_public: true).order(created_at: :desc).limit(100)
  end

  def edit
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])

    if !user_signed_in? && !@survey.is_public
      render plain: t('.expired')
    end
  end
end
