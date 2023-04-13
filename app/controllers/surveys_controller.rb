class SurveysController < ApplicationController
  include SurveyResponsesHelper

  before_action :authenticate_user!

  def index
    @surveys = Survey.order(created_at: :desc).limit(300)
  end

  def show
  end

  def responses
    @survey = Survey.includes(:questions).find(params[:id])
  end

  def download
    survey = Survey.includes(:questions).find(params[:id])
    send_data csv_data(survey), filename: survey.to_filename, type: 'text/csv; charset=utf-8'
  end

  def new
    @survey = Survey.new(is_public: false)
    Survey::DEFAULT_QUESTIONS.times { @survey.questions.build }
    @survey.questions[0].is_required = true
  end

  def edit
    @survey = Survey.includes(:questions).find(params[:id])
  end

  def create
    @survey = Survey.new(survey_params)
    params[:questions].select { |q| q[:title].present? }.each do |question|
      field_type = question[:field_type] == 'multiple' ? 'text_area' : 'text'
      @survey.questions.build(title: question[:title], field_type: field_type, is_required: question[:is_required])
    end

    if @survey.save
      redirect_to surveys_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @survey = Survey.includes(:questions).find(params[:id])
    @survey.assign_attributes(survey_params)

    if @survey.save
      redirect_to edit_survey_path(id: @survey.id), notice: t('.update.saved')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: "Survey was successfully destroyed."
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :description, :is_public)
  end
end
