class Post < ApplicationRecord
	include Comparable

	validates :title, presence: true
	
	has_rich_text :richtext
		
	def <=>(other)
		puts "this details: " + self.inspect
		puts "other details: " + other.inspect
		a_date = self.created_at
		b_date = other.created_at
		if self.override_post_date != nil
			a_date = self.override_post_date
		end
		if other.override_post_date != nil
			b_date = other.override_post_date
		end
		b_date <=> a_date
	end
end
