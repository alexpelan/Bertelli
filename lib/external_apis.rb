module ExternalApis
	
	class Seatgeek
	
		#Seatgeek API key
 		SEATGEEK_API_CLIENT_ID = "MjM4ODE5fDEzNjIzNjMwNDg"
 		SEATGEEK_RECOMMENDATION_URL = "http://api.seatgeek.com/2/recommendations?"
 		SEATGEEK_PERFORMER_URL = "http://api.seatgeek.com/2/performers?q="
	
		#input: performer name string
		#output: hash of performers
		def performer_by_slug(performer_name)
				query_string = SEATGEEK_PERFORMER_URL + performer_name.gsub(" ","-")
		  	file = open(query_string)
		  	response = file.read
		  	performers = JSON.parse(response)
		  	return performers
		end
		
		def recommendations(bucket, postal_code)
			performers_string = build_performer_string(bucket)
			#don't even bother if they haven't added interests yet
	  	if performers_string.length == 0
	  		return nil
	  	end
			
			
			delimiter = ""
  		response = "{\"areas\":["
  		
  		if !postal_code.nil?
  			temp_response = recommendations_by_postal_code(performers_string, postal_code)
  		else
  			temp_response = recommendations_ill_go_anywhere(performers_string)
  		end
  	
  		response = response + temp_response
	  	response = response + "]}"
	  	recommendations = JSON.parse(response)
			
			return recommendations
		end
		
		def recommendations_by_postal_code(performers_string, postal_code)
			response = ""
			query_string = SEATGEEK_RECOMMENDATION_URL + performers_string + postal_code.to_s() + "&client_id=" + SEATGEEK_API_CLIENT_ID + "&per_page=50&range=50mi"
	  	
	  	file = open(query_string)
	  	temp_response = file.read
	  	response = response + temp_response 
	  	return response
		end
		
		def recommendations_ill_go_anywhere(performers_string)
			
			response = ""
			delimiter = ""
			CITIES.each_value do |postal_code|
  			city_query_string = SEATGEEK_RECOMMENDATION_URL + performers_string + "&postal_code="+ postal_code + "&client_id=" + SEATGEEK_API_CLIENT_ID + "&per_page=50"
  			file = open(city_query_string)
  			temp_response = file.read
  			response = response + delimiter + temp_response
  			delimiter = ","
  			file.close
  			
  		end
  		
  		return response
		end
		
		def build_performer_string(bucket)
				delimiter = ""
				performers_string = ""
  	    bucket.line_items.each do |performer|
	  			performers_string = performers_string + delimiter + "performers.id=" + performer.performer_id.to_s()
	  			delimiter = "&"
	  		end
	  		return performers_string
		end
		
		
	end
		
end