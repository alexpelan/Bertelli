class ApplicationController < ActionController::Base
	protect_from_forgery
	
	private	
	
	#look in the session to see if a bucket exists and grab it. If it doesn't create one.
	def current_bucket
		Bucket.find(session[:bucket_id])
	rescue ActiveRecord::RecordNotFound
		bucket = Bucket.create
		session[:bucket_id] = bucket.id
		bucket
	end
	
end
