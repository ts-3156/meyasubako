require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe '#message=' do
    it do
      model = Answer.new(message: "<div>hello</div>.\n")
      expect(model.message).to eq 'hello.'
    end
  end
end
