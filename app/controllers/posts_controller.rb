# Modelled after 'Articles' controller from tutorial: https://guides.rubyonrails.org/getting_started.html
class PostsController < ApplicationController
	def index
		@posts = Post.all
		render layout: "admin"
	end

	def show
		@post = Post.find(params[:id])
	end
	
	def new
		@post = Post.new
		render layout: "postform"
	end
	
	def edit
		@post = Post.find(params[:id])
		
		if @post.override_post_date == nil
			@post.override_post_date = @post.created_at
		end
		render layout: "postform"
	end
	
	def create
		# construct new Post model using :post instance
		# and store ref to it in @post
		@post = Post.new(params.require(:post)
			.permit(:title, :text, :categories, :override_post_date, :richtext)
		)
		
		format_categories
		
		#write post to db
		if @post.save
			# redirect to "show" method of controller
			# that method finds the :post id and displays
			# the show.html.erb page
			redirect_to @post
		else
			render 'new'
		end
	end
	
	def update
		@post = Post.find(params[:id])

		# update instance properties w/ parameter ones
		@post.categories = post_params[:categories]
		@post.title = post_params[:title]
		@post.text = post_params[:text]
		@post.override_post_date = post_params[:override_post_date]
		@post.richtext = post_params[:richtext]
		
		# apply formatting to them
		format_categories

		# store richtext body
		@richtext_body = @post.richtext['body']

		# convert post to json
		@postjson = @post.as_json
		
		# restore richtext body as top-level property richtext
		@postjson['richtext'] = @richtext_body

		# write instance back to db
		if @post.update(@postjson)
			redirect_to @post
		else
			render 'edit'
		end
	end
	
	def destroy
		@post = Post.find(params[:id])
		
		@post.destroy
		
		redirect_to posts_path
	end

	private
		def post_params
			params.require(:post).permit(:title, :text, :categories, :override_post_date, :richtext)
		end
		
	protected
		def format_categories
			cats = @post.categories.split(",")
			cats = cats.map { |c| c.strip }
			cats = cats.sort
			@post.categories = cats*", "
		end
end
