class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.bigint :survey_id
      t.boolean :is_required
      t.string :title
      t.string :note
      t.timestamps
    end
  end
end
