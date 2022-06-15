class AddRootToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :root_id, :integer
  end
end
