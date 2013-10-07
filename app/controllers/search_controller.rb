require 'open-uri'

#TODO: SearchController should become plural at some point - maybe change name to InterestsController?
class SearchController < ApplicationController
	include ExternalApis

  def new
  end

  def create
  	
  	@query = params[:query]
  	logger.debug("got here")
  	sg = Seatgeek.new
  	@performers = sg.performer_by_slug(@query)
  	
  end

  def destroy
  end
end
