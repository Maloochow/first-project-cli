require_relative './park_importer.rb'
require_relative './location_id'
require_relative './weather_importer.rb'

class City
    include Findable, ParkImporter
    attr_reader :zipcode, :id, :name, :state
    attr_accessor :weather_attributes
    @@all = []

    def initialize(identifier)
        # if identifier.to_i > 0
        #     @zipcode = identifier
        #     @state = state_code_by_zip(identifier)
        # else
            @name = identifier
            @id = city_id(identifier)
            @state = state_code_by_city(identifier)
        # end
        @@all << self
        @weather_attributes = {}
    end

    def current_weather
        weather = WeatherImporter.new(city_id: self.id).get_weather_by_city
        # binding.pry
        self.weather_attributes["weather"] = weather["wahr"][0]["main"]
        self.weather_attributes["temperature"] = k_to_f(weather["main"]["mp"]).to_i
        self.weather_attributes["feel like temperature"] = k_to_f(weather["main"]["fl_lik"]).to_i
        self.weather_attributes["highest temperature"] = k_to_f(weather["main"]["mp_max"]).to_i
        self.weather_attributes["lowest temperature"] = k_to_f(weather["main"]["mp_min"]).to_i
        self.weather_attributes["humidity level"] = weather["main"]["humidity"]
        self.weather_attributes["wind speed"] = weather["wind"]["pd"]
        self.weather_attributes["wind degree"] = weather["wind"]["dg"]
        self.weather_attributes
    end

    def parks_list
        parks_by_state(state_code: self.state)
    end

    def k_to_f(number)
        number*9/5 - 459.67
    end

end