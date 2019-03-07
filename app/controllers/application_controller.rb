require 'redcarpet'
require 'redcarpet/render_strip'

class ApplicationController < ActionController::Base
	helper_method :md
	
	def initialize
		@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
			autolink: true, tables: true, strikethrough: true)
		super
	end
	
	def md(text)
		output = @markdown.render(text)
		puts 'markdown output: ' + output
		output
	end
end
