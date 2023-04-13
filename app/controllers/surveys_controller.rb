require 'csv'

class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @surveys = Survey.order(created_at: :desc).limit(300)
  end

  def show
  end

  def responses
    set_responses(7, 1000)
  end

  def download
    set_responses(30, 100000)
    prefix = @survey.title.gsub(/[ 　]/, '_')
    time = Time.zone.now.in_time_zone('Tokyo').strftime("%Y%m%d%H%M%S")
    filename = "#{prefix}-#{time}.csv"
    send_data generate_csv, filename: filename, type: 'text/csv; charset=utf-8'
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

  def set_responses(days, limit)
    @survey = Survey.includes(:questions).find(params[:id])
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

  # Only allow a list of trusted parameters through.
  def survey_params
    params.require(:survey).permit(:title, :description, :is_public)
  end
end
