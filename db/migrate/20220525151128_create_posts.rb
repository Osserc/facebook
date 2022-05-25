class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :postable, polymorphic: true
      t.integer :author_id

      t.timestamps
    end
  end
end
