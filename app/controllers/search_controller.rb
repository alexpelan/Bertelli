require 'open-uri'

#TODO: SearchController should become plural at some point - maybe change name to InterestsController?
class SearchController < ApplicationController
	include ExternalApis

  def create
  	@query = params[:query]
  	sg = Seatgeek.new
  	@performers = sg.performer_by_slug(@query)
  	
  	respond_to do |format|
  		format.html { redirect_to search_path}
  		format.js
  		format.json {render json: @search }
  	end
  	
  end

  def destroy
  end
  
 
end
