module CustomHelpers
	@@base_title = "Aner's Site"
	@@github_url = "https://github.com/argent0"

   def full_title(page_title=nil)
		if page_title.nil?
			@@base_title
		else
			"#{base_title} | #{page_title}"
		end
   end

	def copyright_str
		"Copyright #{Time.now.year} Aner Lucero"
	end

	def github_link
		link_to 'Github', @@github_url
	end
end
