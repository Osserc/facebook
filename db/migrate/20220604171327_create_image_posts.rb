class CreateImagePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :image_posts do |t|
      t.string :title

      t.timestamps
    end
  end
end
