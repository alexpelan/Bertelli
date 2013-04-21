require 'open-uri'

#TODO: SearchController should become plural at some point - maybe change name to InterestsController?
class SearchController < ApplicationController
	set_tab :search

  def new
  end

  def create
  	
  	@query = params[:query]
  	#replace any spaces with dashes 
  	query_string = "http://api.seatgeek.com/2/performers?q=" + @query.gsub(" ","-")
  	file = open(query_string)
  	response = file.read
  	@performers = JSON.parse(response)
  end

  def destroy
  end
end
