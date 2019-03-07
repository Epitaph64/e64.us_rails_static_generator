class AddFieldsToPost1 < ActiveRecord::Migration[5.2]
  def change
	add_column :posts, :categories, :text
	add_column :posts, :override_post_date, :timestamp
  end
end
