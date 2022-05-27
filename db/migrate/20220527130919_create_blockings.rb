class CreateBlockings < ActiveRecord::Migration[7.0]
  def change
    create_table :blockings do |t|
      t.integer :blocker_id
      t.integer :blocked_id

      t.timestamps
    end
  end
end
