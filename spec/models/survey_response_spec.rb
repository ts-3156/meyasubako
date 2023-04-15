require 'rails_helper'

RSpec.describe SurveyResponse, type: :model do
  describe '#save_with_answers!' do
    let(:instance) { described_class.new(survey_id: 1, ip: '127.0.0.1') }
    let(:raw_answers) do
      [
          {question_id: 1, message: 'message1'},
          {question_id: 2, message: 'message2'}
      ]
    end
    subject { instance.save_with_answers!(raw_answers) }
    it do
      expect(described_class.all.size).to eq(0)
      expect(Answer.all.size).to eq(0)
      subject
      expect(described_class.all.size).to eq(1)
      expect(Answer.all.size).to eq(2)
    end
  end
end
