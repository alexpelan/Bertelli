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


end
