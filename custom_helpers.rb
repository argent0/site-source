module CustomHelpers
	@@base_title = "Aner's Site"
	@@github_url = "https://github.com/argent0"

   def full_title(page_title=nil)
		if page_title.nil?
			@@base_title
		else
			"#{base_title} - #{page_title}"
		end
   end

	def copyright_str
		"Copyright #{Time.now.year} Aner Lucero"
	end

	def github_link
		link_to 'Github', @@github_url
	end

	def sub_pages(dir)  
		sitemap.resources.select do |resource|
			resource.path.start_with?(dir)
		end
	end  

	def _is_active(title, tab)
		if title
			re = Regexp.new(title)
			if re.match(tab)
				return "active"
			end
		end
	end

	def navbar_link(text, href)
		return "<li class=\"#{_is_active(current_page.data.title, text)}\">
			#{link_to(text, href)}</li>"
	end
end
