# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bertelli::Application.initialize!

 #Seatgeek API key
 SEATGEEK_API_CLIENT_ID = "MjM4ODE5fDEzNjIzNjMwNDg"
 #Array of top 25 cities by population according to 
 # http://en.wikipedia.org/wiki/List_of_United_States_cities_by_population#Cities_formerly_over_100.2C000_people
 CITIES = {
 		"New York, New York" => "10199",
 		"Los Angeles, California" => "90052",
 		"Chicago, Illinois" => "60607",
 		"Houston, Texas" => "77201",
 		"Philadelphia, Pennsylvania" => "19104",
 		"Phoenix, Arizona" => "85053",
 		"San Antonio, Texas" => "78201",
 		"San Diego, California" => "92139",
 		"Dallas, Texas" => "75201",
 		"San Jose, California" => "95151"
 		
 }