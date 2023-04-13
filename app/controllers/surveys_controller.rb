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

    questions =
        params[:questions].select { |q| sanitize_question(q[:title]).present? }.map do |question|
          Question.new(title: sanitize_question(question[:title]), field_type: parse_field_type(question[:field_type]), is_required: question[:is_required])
        end

    error = nil

    begin
      Survey.transaction do
        @survey.save!
        @survey.questions = questions
      end
    rescue => e
      logger.warn e.inspect
      error = e
    end

    if error
      render :new, status: :unprocessable_entity
    else
      redirect_to surveys_path, notice: t('.create.saved')
    end
  end

  def update
    @survey = Survey.includes(:questions).find(params[:id])
    @survey.assign_attributes(survey_params)

    error = nil

    begin
      @survey.save!
    rescue => e
      logger.warn e.inspect
      error = e
    end

    if error
      render :edit, status: :unprocessable_entity
    else
      redirect_to edit_survey_path(id: @survey.id), notice: t('.update.saved')
    end
  end

  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: "Survey was successfully destroyed."
  end

  private

  def sanitize_question(text)
    ApplicationController.helpers.strip_tags(text).chomp
  end

  def parse_field_type(value)
    value == 'text_area' ? 'text_area' : 'text'
  end

  def survey_params
    params.require(:survey).permit(:title, :description, :is_public)
  end
end
