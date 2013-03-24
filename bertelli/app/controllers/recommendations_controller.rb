require 'open-uri'

class RecommendationsController < ApplicationController
  def list
  	@bucket = current_bucket
  	#todo -  do something if they haven't added anything
  	query_string = "http://api.seatgeek.com/2/recommendations?"
  	performers_string = ""
  	postal_code = "53726"
  	delimiter = ""
  	@bucket.line_items.each do |performer|
  			performers_string = performers_string + delimiter + "performers.id=" + performer.performer_id.to_s()
  			delimiter = "&"
  	end
  	query_string = query_string + performers_string + "&postal_code=" + postal_code + "&client_id=" + SEATGEEK_API_CLIENT_ID
  	
  	file = open(query_string)
  	response = file.read
  	@recommendations = JSON.parse(response)
  end
end
