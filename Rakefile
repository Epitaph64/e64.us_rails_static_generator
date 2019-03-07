# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'nokogiri'

# https://nowaker.net/post/ruby-on-rails-a-static-site-generator.html
namespace :static do
	desc 'Parse index at and remove admin div element'
	task :strip_admin, [:filePath] do |t, args|
	    puts 'Parse index at ' + args[:filePath] + ' and remove admin div element'
		indexFileName = args[:filePath].to_s
		
		indexFile = File.open(indexFileName, "r")
		data = indexFile.read
		indexFile.close
		
		indexDoc = Nokogiri::HTML.parse(data)
		
		indexDoc.search('//div').each do |node|
			if node.class.to_s == "Nokogiri::XML::Element"
				if node.attr("id") == "admin_access"
					node.remove
				end
			end
		end
		
		indexDoc.search('//a').each do |node|
			if node.attributes.length > 0
				v = node.attributes["href"].value
				if v == "/home/index"
					node.attributes["href"].value = "/"
				end
			end
		end
		
		indexFile = File.open(indexFileName, "w")
		indexFile.write(indexDoc)
		indexFile.close
	end
	
	task :strip_packs do
		puts "Strip packs/ ... js files from HTML Head"
		indexFileName = "./out/index.html"
		
		indexFile = File.open(indexFileName, "r")
		data = indexFile.read
		indexFile.close
		
		indexDoc = Nokogiri::HTML.parse(data)
		
		indexDoc.search('//script').each do |node|
			if node.class.to_s == "Nokogiri::XML::Element"
				attrs = node.attributes
				attrs.each do |a|
				    if (a.length > 1)
					  vs = a[1].value.split("/")
					else
					  next
					end
					if (vs.length > 1 && vs[1] == "packs")
					  node.remove
					  next
					end
				end
			end
		end
		
		indexFile = File.open(indexFileName, "w")
		indexFile.write(indexDoc)
		indexFile.close
	end
	
	task :repackage_posts do
		puts "Repackaging posts"
		Dir.chdir './out/posts' do
			puts "Working in directory: " + Dir.pwd
			# repackage posts
			Dir.foreach('.') do |post|
				if post == '.' or post == '..'
					next
				end
				if !File.directory?(Dir.pwd + "/" + post)
					system "mv " + post + " p" + post
					Dir.mkdir post unless File.exist? post
					system "mv p" + post + " ./" + post + "/index.html"
					filePathArg = Dir.pwd + "/" + post + "/index.html"
					puts "Processing " + filePathArg
					Rake::Task["static:strip_admin"].execute({filePath: filePathArg})
				end
			end
		end
	end

	desc 'Generate static site in ./out/ directory'
	task :generate do
		Dir.mkdir 'out' unless File.exist? 'out'
		Dir.chdir 'out' do
			# wget -m: infinite recursive depth, time-stamping, and keep FTP directory listings
			# wget -nH: no host directories (this strips the domain name from the directory structure)
			`wget -mnH http://localhost:3001/ -o /dev/null -R '*edit*'`
		end
		# rsync -r: recurse into directories
		# rsync -u: update mode (skip newer files on receiving end)
		# rsync -v: verbose output
		`rsync -ruv --exclude=.git/ public/ out/`
		# strip GET parameters from out/assets/css filenames
		
		puts 'Renaming output css files'
		`bash "process_out_css.sh"`
		`rm ./out/assets/Usage*`
		
		# strip admin panel from index.html
		Rake::Task["static:strip_admin"].execute({filePath: "./out/index.html"})
		# strip admin panel from index.html
		Rake::Task["static:strip_packs"].invoke
		# remove admin file
		`rm ./out/admin`
		
		# remove unneeded directories in static output
		`rm -r ./out/packs`
		
		Rake::Task["static:repackage_posts"].invoke
	end
	
	desc 'Run tiny HTTP server from ./out/ directory'
	task :server do
		Dir.chdir 'out' do
			puts 'Started HTTP server at http://localhost:8001/.
			Press CTRL+C to Exit.'
			`python -m SimpleHTTPServer 8001`
		end
	end
end

Rails.application.load_tasks
