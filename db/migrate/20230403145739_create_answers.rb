class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.bigint :survey_response_id
      t.bigint :question_id
      t.text :message
      t.timestamps

      t.index :survey_response_id
      t.index :created_at
    end
  end
end
