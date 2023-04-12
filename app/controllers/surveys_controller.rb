require 'csv'

class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, only: %i[ show edit update destroy ]

  # GET /surveys
  def index
    @surveys = Survey.order(created_at: :desc).limit(300)
  end

  # GET /surveys/1
  def show
  end

  def responses
    set_responses(7, 1000)
  end

  def download
    set_responses(30, 100000)
    data = generate_csv
    filename = "results-#{(Time.zone.now.in_time_zone('Tokyo')).to_fs(:db)}.csv"
    send_data data, filename: filename, type: 'text/csv; charset=utf-8'
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
      @survey.questions.build(title: question[:title], field_type: question[:field_type] == 'multiple' ? 'text_area' : 'text', is_required: question[:is_required])
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

  def set_responses(days, limit)
    @survey = Survey.includes(:questions).find_by_token(params[:survey_token])
    @days = days
    @limit = limit
    from_time = parse_time(params[:from_time]) || @days.days.ago
    to_time = parse_time(params[:to_time]) || Time.zone.now
    @survey_responses = SurveyResponse.includes(:answers).
        where(survey_id: @survey.id).
        where(created_at: from_time..to_time).
        order(created_at: :desc).
        limit(@limit)
  end

  def generate_csv
    CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      csv << ['', 'Time', 'IP', @survey.questions.map(&:title)].flatten
      @survey_responses.reverse.each.with_index do |survey_response, i|
        csv << [i + 1, survey_response.created_at.to_fs(:db), survey_response.ip, survey_response.answers.map(&:message)].flatten
      end
    end
  end

  def parse_time(value)
    value.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/) ? Time.zone.parse(value) : nil
  rescue => e
    nil
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def survey_params
    params.require(:survey).permit(:title, :description, :is_public)
  end
end
