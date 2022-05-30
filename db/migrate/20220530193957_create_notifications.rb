class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :receiver_id
      t.integer :originator_id
      t.integer :event_id
      t.string :message
      t.boolean :read, default: false
      
      t.timestamps
    end
  end
end
