class CreateSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_responses do |t|
      t.bigint :survey_id
      t.string :ip
      t.string :browser
      t.string :os
      t.string :device_type
      t.timestamps

      t.index :survey_id
      t.index :created_at
    end
  end
end
