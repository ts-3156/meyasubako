require 'digest/md5'

3.times.with_index do |survey_counter|
  survey = Survey.create!(is_public: survey_counter == 2, title: "survey#{survey_counter + 1}", description: "This is a description.\nHello!")

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
end

puts (email = "#{SecureRandom.hex(12)}@example.com")
puts (password = SecureRandom.hex(12))
File.write('login.txt', email + "\n" + password)

User.create!(email: email, password: password)
