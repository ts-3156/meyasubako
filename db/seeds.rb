require 'digest/md5'

puts (email = "#{SecureRandom.hex(6)}@example.com")
puts (password = SecureRandom.hex(12))
File.write('admin.txt', email + "\n" + password)
User.create!(email: email, password: password)

titles = I18n.t('seed.titles')
descriptions = I18n.t('seed.descriptions')

3.times do |survey_i|
  survey = Survey.create!(is_public: survey_i == 1, title: titles[survey_i], description: descriptions[survey_i])

  survey.questions.create!(field_type: 'text', is_required: true, title: I18n.t('seed.questions')[0], note: 'This is a note.')
  survey.questions.create!(field_type: 'text_area', is_required: false, title: I18n.t('seed.questions')[1], note: 'This is a note.')
  survey.questions.create!(field_type: 'text_area', is_required: false, title: I18n.t('seed.questions')[2], note: 'This is a note.')

  responses_count = 2400

  responses_count.times do |n|
    survey_response = SurveyResponse.create!(survey_id: survey.id, ip: '127.0.0.1', browser: 'Chrome', os: 'Mac', device_type: 'smartphone', created_at: Time.zone.now - (responses_count - n).seconds)

    survey.questions.each do |question|
      message = "This answer is for res##{survey_response.id} and q##{question.id}."
      survey_response.answers.create!(question_id: question.id, message: message)
    end
  end
end
