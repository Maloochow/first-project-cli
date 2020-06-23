require 'pry'
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

BASE_URL = URI("https://community-open-weather-map.p.rapidapi.com/weather?callback=test&zip=10002,us")

http = Net::HTTP.new(BASE_URL.host, BASE_URL.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(BASE_URL)
request["x-rapidapi-host"] = 'community-open-weather-map.p.rapidapi.com'
request["x-rapidapi-key"] = 'b863098360mshb385b458118490ap193c86jsn956ad95a914b'

response = http.request(request)
binding.pry
weather = JSON.parse(response.body)

