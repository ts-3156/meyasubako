require 'digest/md5'

survey = Survey.create!(is_public: true, title: 'survey1', description: 'desc')
survey.update!(survey_token: Digest::MD5.hexdigest("#{Time.zone.now.to_i}-#{survey.title}"))

Survey.transaction do
  survey.questions.create!(survey_id: survey.id, is_required: true, title: 'question1', note: 'note1')
  survey.questions.create!(survey_id: survey.id, is_required: true, title: 'question2', note: 'note2')
  survey.questions.create!(survey_id: survey.id, is_required: false, title: 'question3', note: 'note3')
  survey.questions.create!(survey_id: survey.id, is_required: false, title: 'question4', note: 'note4')
  survey.questions.create!(survey_id: survey.id, is_required: false, title: 'question5', note: 'note5')
  survey.questions.create!(survey_id: survey.id, is_required: false, title: 'question6', note: 'note6')
  survey.questions.create!(survey_id: survey.id, is_required: false, title: 'question7', note: 'note7')
end

200.times do |n|
  SurveyResponse.transaction do
    survey_response = SurveyResponse.create(survey_id: survey.id, ip: '127.0.0.1', created_at: Time.zone.now - (200 - n).minutes)

    survey.questions.size.times do |i|
      survey_response.answers.create(message: "answer#{i + 1}")
    end
  end
end
