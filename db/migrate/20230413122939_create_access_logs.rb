class CreateAccessLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :access_logs do |t|
      t.string :controller
      t.string :action
      t.string :method
      t.string :path
      t.text :params
      t.integer :status
      t.string :ip
      t.string :browser
      t.string :os
      t.string :device_type
      t.text :user_agent
      t.text :referer
      t.datetime :time

      t.index :time
    end
  end
end
