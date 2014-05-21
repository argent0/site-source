module CustomHelpers
	@@base_title = "Aner's Site"

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
end
