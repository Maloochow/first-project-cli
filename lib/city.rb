require_relative './park_importer.rb'
require_relative './location_id'
require_relative './weather_importer.rb'

class City
    include Findable, ParkImporter
    # extend Findable::ClassMethod
    attr_reader :zipcode, :id, :name, :state, :city_o
    attr_accessor :weather_attributes
    @@all = []

    def initialize(name:, state: nil)
        if state == nil
            array = city_objects(name)
            if array.count == 1
                @city_o = array[0]
                @name = city_o["name"]
                @id = city_o["id"]
                @state = city_o["state"]
                @@all << self
                @weather_attributes = {}
            elsif array.count == 0
                @city_o = nil
            else
                @city_o = array
            end
        else
            @city_o = find_city(name, state)
            @name = city_o["name"]
            @id = city_o["id"]
            @state = city_o["state"]
            @@all << self
            @weather_attributes = {}
        end
        @city_o
            # if identifier.to_i > 0
            #     @zipcode = identifier
            #     @state = state_code_by_zip(identifier)
            # else
            # end
    end

    def self.all
        @@all
    end

    def self.create(input_name, input_state)
        City.new(name: input_name, state: input_state)
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
        previous_city = self.class.all[-2]
        if previous_city != nil && self.state == previous_city.state
            nil
        else
        parks_by_state(state_code: self.state)
        end
    end

    def k_to_f(number)
        number*9/5 - 459.67
    end

end