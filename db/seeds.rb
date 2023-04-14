require 'digest/md5'

puts (email = "#{SecureRandom.hex(6)}@example.com")
puts (password = SecureRandom.hex(12))
File.write('admin.txt', email + "\n" + password)
User.create!(email: email, password: password)

titles = I18n.t('seed.titles')

titles.each.with_index do |title, title_i|
  survey = Survey.create!(is_public: title_i == 1, title: title, description: "This is a description.\nVisit https://example.com")

  survey.questions.create!(field_type: 'text', is_required: true, title: 'What is your name?', note: 'This is a note.')
  survey.questions.create!(field_type: 'text', is_required: true, title: 'What is this?', note: 'This is a note.')
  survey.questions.create!(field_type: 'text', is_required: false, title: 'What is this?', note: 'This is a note.')
  survey.questions.create!(field_type: 'text_area', is_required: true, title: 'What is this?', note: 'This is a note.')
  survey.questions.create!(field_type: 'text_area', is_required: true, title: 'What is this?', note: 'This is a note.')
  survey.questions.create!(field_type: 'text_area', is_required: false, title: 'What is this?', note: 'This is a note.')
  survey.questions.create!(field_type: 'text_area', is_required: false, title: 'What is this?', note: 'This is a note.')

  responses_count = 3600

  responses_count.times do |n|
    survey_response = SurveyResponse.create!(survey_id: survey.id, ip: '127.0.0.1', browser: 'Chrome', os: 'Mac', device_type: 'smartphone', created_at: Time.zone.now - (responses_count - n).seconds)

    survey.questions.each do |question|
      message = "This answer is for res##{survey_response.id} and q##{question.id}."
      survey_response.answers.create!(question_id: question.id, message: message)
    end
  end
end
