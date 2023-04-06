class CreateSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_responses do |t|
      t.bigint :survey_id
      t.string :ip
      t.timestamps
    end
  end
end
