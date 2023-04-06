class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, only: %i[ show edit update destroy ]

  # GET /surveys
  def index
    @surveys = Survey.order(created_at: :desc).limit(100)
  end

  # GET /surveys/1
  def show
  end

  # GET /surveys/new
  def new
    @survey = Survey.new(is_public: false)
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  def create
    @survey = Survey.new(survey_params)
    params[:questions].select { |q| q[:title].present? }.each do |question|
      @survey.questions.build(title: question[:title])
    end

    if @survey.save
      redirect_to surveys_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /surveys/1
  def update
    if @survey.update(survey_params)
      redirect_to @survey, notice: "Survey was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: "Survey was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def survey_params
    params.require(:survey).permit(:title, :description, :is_public)
  end
end
