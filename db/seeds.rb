# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

survey = Survey.create!(survey_token: 'aaa', is_public: true, title: 'survey1', description: 'desc')

Survey.transaction do
  survey.questions.create!(survey_id: survey.id, title: 'question1')
  survey.questions.create!(survey_id: survey.id, title: 'question2')
  survey.questions.create!(survey_id: survey.id, title: 'question3')
end

SurveyResponse.transaction do
  survey_response = SurveyResponse.create(survey_id: survey.id)

  survey_response.answers.create(message: 'answer1')
  survey_response.answers.create(message: 'answer2')
  survey_response.answers.create(message: 'answer3')
end
