require 'digest/md5'

titles = ['What is your favorite food?', 'What is your favorite sport?', 'What is your favorite book?']

2.times.with_index do |survey_counter|
  survey = Survey.create!(is_public: survey_counter == 1, title: titles[survey_counter], description: "This is a description.\nVisit https://example.com")

  Survey.transaction do
    survey.questions.create!(field_type: 'text', is_required: true, title: 'What is your name?', note: 'This is a note.')
    survey.questions.create!(field_type: 'text', is_required: true, title: 'What is this?', note: 'This is a note.')
    survey.questions.create!(field_type: 'text', is_required: false, title: 'What is this?', note: 'This is a note.')
    survey.questions.create!(field_type: 'text_area', is_required: true, title: 'What is this?', note: 'This is a note.')
    survey.questions.create!(field_type: 'text_area', is_required: true, title: 'What is this?', note: 'This is a note.')
    survey.questions.create!(field_type: 'text_area', is_required: false, title: 'What is this?', note: 'This is a note.')
    survey.questions.create!(field_type: 'text_area', is_required: false, title: 'What is this?', note: 'This is a note.')
  end

  responses_count = 3600

  responses_count.times do |n|
    SurveyResponse.transaction do
      survey_response = SurveyResponse.create(survey_id: survey.id, ip: '127.0.0.1', created_at: Time.zone.now - (responses_count - n).seconds)

      survey.questions.each do |question|
        message = "This answer is for res##{survey_response.id} and q##{question.id}."
        survey_response.answers.create(question_id: question.id, message: message)
      end
    end
  end
end

puts (email = "#{SecureRandom.hex(6)}@example.com")
puts (password = SecureRandom.hex(12))
File.write('login.txt', email + "\n" + password)

User.create!(email: email, password: password)
