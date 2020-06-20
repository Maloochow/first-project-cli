require 'pry'
require 'uri'
require 'net/http'
require 'openssl'
require 'json'


class WeatherImporter

BASE_URL = "https://community-open-weather-map.p.rapidapi.com/weather?callback=test&"

attr_reader :city_id, :zip_code

    def initialize(city_id: nil)
        @city_id = city_id
        # @zip_code = zip_code
    end

    def get_weather_by_city
        url =URI(BASE_URL + "id=#{city_id}")
        weather_hash(url)
    end

    def get_weather_by_zip
        url =URI(BASE_URL + "zip=#{zip_code},us")
        weather_hash(url)
        # binding.pry
    end


    
    def weather_hash(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'community-open-weather-map.p.rapidapi.com'
        request["x-rapidapi-key"] = 'b863098360mshb385b458118490ap193c86jsn956ad95a914b'
        
        response = http.request(request)
        weather = JSON.parse(response.body[5..-2])
    end
    
    # sample urls
    # url = URI("https://community-open-weather-map.p.rapidapi.com/weather?callback=test&q=New%20York%20City")
    # url = URI("https://community-open-weather-map.p.rapidapi.com/weather?callback=test&id=5128581")
    # url = URI("https://community-open-weather-map.p.rapidapi.com/weather?callback=test&zip=10002,us")
    
    # weather["wahr"][0]["main"]


# puts response.read_body.css("weather")
# JSON.parse(response.read_body)


# BASE_URL = "api.openweathermap.org/data/2.5/weather?zip="
# # Examples of API calls:
# # api.openweathermap.org/data/2.5/weather?zip=94040,us

# weather_zip = JSON.parse(BASE_URL + "10002,us" + "&appid=b863098360mshb385b458118490ap193c86jsn956ad95a914b")
# binding.pry


end