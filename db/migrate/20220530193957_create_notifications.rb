class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :receiver_id
      t.integer :issuer_id
      t.references :notifiable, polymorphic: true
      t.boolean :read, default: false
      t.boolean :retracted, default: false
      
      t.timestamps
    end
  end
end
