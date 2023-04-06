class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.string :survey_token
      t.boolean :is_public
      t.string :title
      t.text :description
      t.timestamps

      t.index :survey_token, unique: true
      t.index :created_at
    end
  end
end
