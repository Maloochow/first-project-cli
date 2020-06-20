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

            @name = format_city_name(identifier)
            @id = city_id(@name)
            @state = state_code_by_city(@name)
        # end
        @@all << self
        @weather_attributes = {}
    end

    def current_weather
        weather = WeatherImporter.new(city_id: self.id).get_weather_by_city
        self.weather_attributes["weather"] = weather["weather"][0]["description"]
        self.weather_attributes["temperature"] = k_to_f(weather["main"]["temp"]).to_i
        self.weather_attributes["feel like temperature"] = k_to_f(weather["main"]["feels_like"]).to_i
        self.weather_attributes["highest temperature"] = k_to_f(weather["main"]["temp_max"]).to_i
        self.weather_attributes["lowest temperature"] = k_to_f(weather["main"]["temp_min"]).to_i
        self.weather_attributes["humidity level"] = weather["main"]["humidity"]
        self.weather_attributes["wind speed"] = weather["wind"]["speed"]
        self.weather_attributes["wind degree"] = weather["wind"]["deg"]
        self.weather_attributes
    end

    def create_parks_list
        parks_by_state(state_code: self.state)
    end

    def k_to_f(number)
        number*9/5 - 459.67
    end

end