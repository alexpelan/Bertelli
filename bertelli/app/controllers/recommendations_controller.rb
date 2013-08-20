require 'open-uri'


class RecommendationsController < ApplicationController
	include BertelliLib
	set_tab :recommendations

	#TODO: something about "fat models, skinny controllers" :-)
  def list
  	@bucket = current_bucket
  	#todo -  do something if they haven't added anything
  	query_string = "http://api.seatgeek.com/2/recommendations?"
  	performers_string = ""
  	postal_code_string = ""
  	response = ""
  	postal_code = params[:postal_code]
  	@ill_go_anywhere_mode = false
  	
  	if postal_code.nil? 
  		@ill_go_anywhere_mode = true
   	else 
   		postal_code = postal_code.to_i()
   		
   		#return with no results if the postal code is invalid
   		if postal_code == 0
   			return
   		end
 
  		postal_code_string = "&postal_code=" + postal_code.to_s()
  	end
  	
  	delimiter = ""
  	@bucket.line_items.each do |performer|
  			performers_string = performers_string + delimiter + "performers.id=" + performer.performer_id.to_s()
  			delimiter = "&"
  	end
  	
  	#don't even bother if they haven't added interests yet
  	if performers_string.length == 0
  		return
  	end
  	
  	delimiter = ""
  	response = "{\"areas\":["
  	if @ill_go_anywhere_mode
  		
  		CITIES.each_value do |postal_code|
  			city_query_string = query_string + performers_string + "&postal_code="+ postal_code + "&client_id=" + SEATGEEK_API_CLIENT_ID + "&per_page=50"
  			logger.info("zip = " + postal_code)
  			file = open(city_query_string)
  			temp_response = file.read
  			response = response + delimiter + temp_response
  			delimiter = ","
  			file.close
  			
  		end
  			
  	else
	  	query_string = query_string + performers_string + postal_code_string + "&client_id=" + SEATGEEK_API_CLIENT_ID + "&per_page=50&range=50mi"
	  	
	  	@str = query_string
	  	file = open(query_string)
	  	temp_response = file.read
	  	response = response + temp_response
	  	
	  end
	 
	  response = response + "]}"
	  
	  @recommendations = JSON.parse(response)
	  
  	@weekend_events = Hash.new
  	
    @recommendations["areas"].each do |city|
	  	#@recommendations["recommendations"].each do |recommendation|
	  	city["recommendations"].each do |recommendation|
	  		event_date = Date.new
	    	event_date = Date.parse(recommendation["event"]["datetime_local"])
	  		if is_the_freakin_weekend(event_date)
	  		  #store the date string so we can sort on it easily
	  			@weekend_events.store(recommendation,event_date)			
	  		end
	  		
	    end
   	end
   	
   	#here's where the magic happens. Hardcoding minimum number of events to 2 for now
   	@weekends = group_into_weekends(@weekend_events, 2)
   	
   	#if they didn't provide a zip code, now we have to search through weekends to see if any events are in the same general area
   	if @ill_go_anywhere_mode 
   		@weekends = group_by_location(@weekends, 2, 50)	
   	end
   	
  end
  
  def new
  end
  
  
  
  
  #not I18N'ed - assumes a Fri/Sat/Sun weekend
  def is_the_freakin_weekend(date)
  	day_of_week = date.wday
  	if day_of_week == 0 || day_of_week == 5 || day_of_week == 6
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
  	sorted_events = Hash.new
  	
  	#sort events in date order
  	sorted_events = events.sort_by {|key,value| value}
  	
  	#iterate through hash in date order
  	sorted_events.each do |event, event_date|
  		
  		#if this isn't the first event within a weekend, check if this event is within 2 days of the previous one
  		#if it is, it's part of that weekend (and can't be part of the next weekend, because math)
 			if weekend.size > 0
 				if event_date - previous_date <= 2			  
 					weekend.push(event.clone)
 					previous_date = event_date
 				else
 					need_to_create_new_weekend = true
 				end
  		end
  		
  		#first time through, or if the current date doesn't fit in the weekend
  		if need_to_create_new_weekend == true
  			if weekend.size >= minimum_number_of_events
  				weekends.push(weekend.clone) #clone because otherwise modifying weekend modifies the value in the array as well
  			end
  			weekend.clear
  			weekend.push(event.clone)
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
  
  #input: array of weekends
  #returns: array of weekends
  #description: looks in weekends to find events in the same geographic area
  def group_by_location(weekends,minimum_number_of_events,range_in_miles)
  	location_weekends = Array.new
  	new_location_group = Array.new
  	already_grouped_event_indices = Hash.new
  	
  	#loop through - should be a small amount of events so we can probably just compare every event with every other one 
  	#as long as this never hits techcrunch then i think that'll be fine
  	weekends.each do |weekend|
  		
  		already_grouped_event_indices.clear
  		
  		weekend.each_with_index do |event, index|
  			#save our weekend off if it's big enough
  			if new_location_group.size >= minimum_number_of_events
  				location_weekends.push(new_location_group.clone) #again, .clone because references 
  			end
  		
  			new_location_group.clear
  		
  			if already_grouped_event_indices.has_key?(index) 
  				next
  			end
  				
  			lat1 = event["event"]["venue"]["location"]["lat"]
  			long1 = event["event"]["venue"]["location"]["lon"]
  			title1 = event["event"]["title"]
  			
  			#compare each array element with all events after it
  			for j in (index+1)..(weekend.size-1)
  
					if already_grouped_event_indices.has_key?(j)
						next
					end  
 
 				  internal_loop_event = weekend[j]
  			  lat2 = internal_loop_event["event"]["venue"]["location"]["lat"]
  			  long2 = internal_loop_event["event"]["venue"]["location"]["lon"]
  			  title2 = internal_loop_event["event"]["title"]
  			  
  			  val = calculate_distance(lat1,long1,lat2,long2) 
  			  
  			  if calculate_distance(lat1,long1,lat2,long2) < range_in_miles
  			  
  			  	if new_location_group.size == 0
  			  
  			  		new_location_group.push(event.clone)
  			  		already_grouped_event_indices[index] = true
  			  	end
  			  	
  			  	new_location_group.push(internal_loop_event.clone)
  			  	already_grouped_event_indices[j] = true
  			  	
  			  
  			  	
  			  end
  				
  			end
  			
  		end
  	end
  	
  	return location_weekends
  end
  
 
  
end
