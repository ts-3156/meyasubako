class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.bigint :survey_id
      t.string :field_type
      t.boolean :is_required
      t.string :title
      t.string :note
      t.timestamps

      t.index :survey_id
      t.index :created_at
    end
  end
end
