class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.integer :friend_one_id
      t.integer :friend_two_id

      t.timestamps
    end
  end
end
