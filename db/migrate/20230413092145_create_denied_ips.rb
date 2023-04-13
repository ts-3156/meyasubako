class CreateDeniedIps < ActiveRecord::Migration[7.0]
  def change
    create_table :denied_ips do |t|
      t.string :ip
      t.timestamps

      t.index :ip, unique: true
      t.index :created_at
    end
  end
end
