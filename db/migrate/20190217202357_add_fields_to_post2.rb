class AddFieldsToPost2 < ActiveRecord::Migration[6.0]
  def change
	add_column :posts, :richtext, :has_rich_text
  end
end
