require 'pry'
require 'uri'
require 'net/http'
require 'openssl'

url = URI("https://community-open-weather-map.p.rapidapi.com/weather?callback=test&id=2172797&units=%2522metric%2522%20or%20%2522imperial%2522&mode=xml%252C%20html&q=London%252Cuk")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["x-rapidapi-host"] = 'community-open-weather-map.p.rapidapi.com'
request["x-rapidapi-key"] = 'b863098360mshb385b458118490ap193c86jsn956ad95a914b'

response = http.request(request)
puts response.read_body