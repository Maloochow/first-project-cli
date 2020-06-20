require 'pry'
require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require_relative './weather_importer.rb'

module Findable
    # ZIP_URL = "https://vanitysoft-boundaries-io-v1.p.rapidapi.com/reaperfire/rest/v1/public/boundary?zipcode="
    def format_city_name(name)
        file = File.read('db/city.list.json')
        data_hash = JSON.parse(file)
        city_o = data_hash.find {|hash| hash["name"].downcase == name.downcase}
        # binding.pry
        city_o ? city_o["name"] : nil
    end

    def city_id(name)
        file = File.read('db/city.list.json')
        data_hash = JSON.parse(file)
        city_o = data_hash.find {|hash| hash["name"] == name}
        # binding.pry
        city_o ? city_o["id"] : nil
    end
    
    def state_code_by_city(name)
        file = File.read('db/city.list.json')
        data_hash = JSON.parse(file)
        city_o = data_hash.find {|hash| hash["name"] == name}
        city_o ? city_o["state"] : nil
    end
    
    def state_code_by_zip(zipcode)
        w = WeatherImporter.new(zip_code: zipcode)
        city_s = w.get_weather_by_zip["nam"]
        file = File.read('db/city.list.json')
        data_hash = JSON.parse(file)
        city_o = data_hash.select {|hash| hash["name"][0,2] == city_s[0,2] && hash["name"][-5,5] == city_s[-5,5]}
        binding.pry
        city_o["state"]

        # url = URI(ZIP_URL + "#{zipcode}")
        # # url = URI("https://vanitysoft-boundaries-io-v1.p.rapidapi.com/reaperfire/rest/v1/public/boundary?zipcode=10002")
        # http = Net::HTTP.new(url.host, url.port)
        # http.use_ssl = true
        # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        # request = Net::HTTP::Get.new(url)
        # request["x-rapidapi-host"] = 'vanitysoft-boundaries-io-v1.p.rapidapi.com'
        # request["x-rapidapi-key"] = 'b863098360mshb385b458118490ap193c86jsn956ad95a914b'
        
        # response = http.request(request)
        # response_j = JSON.parse(response.read_body)
        # binding.pry
        # i = response_j["features"][0]["properties"]["state"]
        # i ? i : "Sorry, the location you entered is out of my scope (＞人＜;)"

    end
        
        
        
        # def valid_zip?
        
    #     ^[0-9]{5}(?:-[0-9]{4})?$

    # end



end


# file = File.read('db/city.list.json')
# data_hash = JSON.parse(file)
# data_hash.map do |hash|
#     hash["id"]
# end