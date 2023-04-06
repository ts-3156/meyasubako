class CreateBlockedIps < ActiveRecord::Migration[7.0]
  def change
    create_table :blocked_ips do |t|
      t.string :ip, unique: true
      t.timestamps
    end
  end
end
