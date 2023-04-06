class HomeController < ApplicationController
  def index
    if (survey = Survey.order(created_at: :desc).find_by(is_public: true))
      redirect_to form_path(survey_token: survey.survey_token)
    else
      render plain: 'There are no surveys'
    end
  end
end