#A place to put shared code.Since it's one function right now it doesn't really need any organization
module BertelliLib

	RADIUS_OF_EARTH_KM = 6371
	PIx = 3.141592653589793
	
	#a function to calculate the number of miles between two sets of (lat,long) coordinates
	#shamelessly stolen from http://stackoverflow.com/questions/27928/how-do-i-calculate-distance-between-two-latitude-longitude-points
	def calculate_distance(lat1,long1,lat2,long2)
		delta_long = convert_degrees_to_radians(long2 - long1)
		delta_lat = convert_degrees_to_radians(lat2 - lat1)
		
		a = (Math.sin(delta_lat / 2) * Math.sin(delta_lat / 2)) + Math.cos(convert_degrees_to_radians(lat1)) * Math.cos(convert_degrees_to_radians(lat2)) * (Math.sin(delta_long / 2) * Math.sin(delta_long / 2))
		angle = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
		return angle * RADIUS_OF_EARTH_KM
	end
	
	def convert_degrees_to_radians(degrees)
		return degrees * PIx / 180
	end

end