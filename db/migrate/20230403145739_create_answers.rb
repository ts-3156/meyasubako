class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.bigint :survey_response_id
      t.text :message
      t.timestamps
    end
  end
end
