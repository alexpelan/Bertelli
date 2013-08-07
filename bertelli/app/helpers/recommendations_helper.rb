module RecommendationsHelper

	#turns a day from the weekend into an end user facing date, eg Friday May 6th-Sunday May 8th
	def calculate_date_string(date)
		event_date = Date.parse(date)
		start_date = Date.new
		end_date = Date.new
		if event_date.wday == 5 #friday
			start_date = event_date
			end_date = event_date + 2
		elsif event_date.wday == 6 #saturday
			start_date = event_date - 1
			end_date = event_date + 1
		elsif event_date.wday == 0 #sunday
			state_date = event_date - 2
			end_date = event_date
		end
		date_string = start_date.to_time.strftime("%m/%d/%Y") + " - " + end_date.to_time.strftime("%m/%d/%Y")
		
		return date_string
	end
	
	def format_date_day_month(date)
		date_to_format = Date.parse(date)
		date_string = date_to_format.to_time.strftime("%m/%d")
		return date_string
	end
	
	def find_first_available_image(weekend)
		#find the first image that actually exists and return that. return broken image if none of the performers have an associated image
		weekend.each do |event|
			first_performer = event["event"]["performers"].first
			
			if (!first_performer["images"]["large"].nil?)
				return first_performer["images"]["large"]
			end
			
		end
		
		return "brokenimage.png"
	
	end
	
	def truncate_string(string,desired_return_string_length)
		if string.length <= desired_return_string_length
			return string
		else
			return string[0..desired_return_string_length] + "..."
		end
	end


end
