require 'open-uri'

class RecommendationsController < ApplicationController
  def list
  	@bucket = current_bucket
  	#todo -  do something if they haven't added anything
  	query_string = "http://api.seatgeek.com/2/recommendations?"
  	performers_string = ""
  	postal_code = params[:postal_code]
  	delimiter = ""
  	@bucket.line_items.each do |performer|
  			performers_string = performers_string + delimiter + "performers.id=" + performer.performer_id.to_s()
  			delimiter = "&"
  	end
  	query_string = query_string + performers_string + "&postal_code=" + postal_code + "&client_id=" + SEATGEEK_API_CLIENT_ID
  	
  	@str = query_string
  	file = open(query_string)
  	response = file.read
  	@recommendations = JSON.parse(response)
  	@weekend_events = Hash.new
  	
  	@recommendations["recommendations"].each do |recommendation|
  		event_date = Date.new
    	event_date = Date.parse(recommendation["event"]["datetime_local"])
  		if is_the_freakin_weekend(event_date)
  			#use the date string as the key so we can more easily check whether events are grouped in a weekend
  			@weekend_events.store(event_date,recommendation)			
  		end
  		
    end
   		
   	#here's where the magic happens. Hardcoding minimum number of events to 2 for now
   	@weekends = group_into_weekends(@weekend_events,2)
   	
   	
  end
  
  def new
  end
  
  #not I18N'ed - assumes a Fri/Sat/Sun weekend
  def is_the_freakin_weekend(date)
  	if date.wday == 0 || date.wday == 5 || date.wday == 6
  		return true
  	else
  		return false
  	end
  end
  
  def group_into_weekends(events,minimum_number_of_events)
  	weekends = Array.new
  	need_to_create_new_weekend = true
  	weekend = Array.new
  	previous_date = Date.new
  	
  	#iterate through hash in date order
  	events.keys.sort.each do |event_date|
  		
  		#if this isn't the first event within a weekend, check if this event is within 2 days of the previous one
  		#if it is, it's part of that weekend (and can't be part of the next weekend, because math)
 			if weekend.size > 0
 				if event_date - previous_date <= 2
 					weekend.push(events[event_date])
 					previous_date = event_date
 				else
 					need_to_create_new_weekend = true
 				end
  		end
  		
  		#first time through, or if the current date doesn't fit in the weekend
  		if need_to_create_new_weekend == true
  			if weekend.size >= minimum_number_of_events
  				weekends.push(weekend)
  			end
  			weekend.clear
  			weekend.push(events[event_date])
  			previous_date = event_date
  			need_to_create_new_weekend = false
  		end
  	
 	
  	end
  	
  	#anything left over in our weekend array
    if weekend.size >= minimum_number_of_events
    	weekends.push(weekend)
    end
    
  	
  	return weekends
  end 
  
end
