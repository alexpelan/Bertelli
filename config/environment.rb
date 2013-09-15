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
 		"San Jose, California" => "95151",
 		"Austin, Texas" => "78774",
 		"Jacksonville, Florida" => "32073",
 		"Indianapolis, Indiana" => "46201",
 		"San Francisco, California" => "94102",
 		"Columbus, Ohio" => "43085",
 		"Fort Worth, Texas" => "76101",
 		"Charlotte, North Carolina" => "28201",
 		"Detroit, Michigan" => "48201",
 		"El Paso, Texas" => "79901",
 		"Memphis, Tennessee" => "37501",
 		"Boston, Massachusetts" => "02108",
 		"Seattle, Washington" => "98101",
 		"Denver, Colorado" => "80201",
 		"Washington, DC" => "20001",
 		"Nashville, Tennesse" => "37201",
 		"Baltimore, Maryland" => "21201",
 		"Louisville, Kentucky" => "40201",
 		"Portland, Oregon" => "97201",
 		"Oklahoma City, Oklahoma" => "73101",
 		"Milwaukee, Wisconsin" => "53201",
 		"Las Vegas, Nevada" => "89101",
 		"Albuquerque, New Mexico" => "87101",
 		"Tucson, Arizona" => "85701",
 		"Kansas City, Missouri" => "64101",
 		"Virginia Beach, Virginia" => "23450",
 		"Atlanta, Georgia" => "30301",
 		"Raleigh, North Carolina" => "27601",
 		"Omaha, Nebraska" => "68101",
 		"Miami, Florida" => "33101",
 		"Tulsa, Oklahoma" => "74101",
 		"Minneapolis, Minnesota" => "55401",
 		"Cleveland, Ohio" => "44101",
 		"Wichita, Kansas" => "67201",
 		
 }