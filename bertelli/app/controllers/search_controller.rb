require 'open-uri'

class SearchController < ApplicationController
  def new
  end

  def create
  	@query = params[:query]
  	query_string = "http://api.seatgeek.com/2/performers?q=" + @query.gsub(" ","-")
  	file = open(query_string)
  	response = file.read
  	@performers = JSON.parse(response)
  end

  def destroy
  end
end
