require 'pry'
require_relative '../config/environment'

class Controller

attr_reader :city

def call
    puts "Welcome to the Healthy Weather Station ٩( 'ω' )و"
    puts "Please enter a city name from the United States to check local weather:"
    input = gets.strip
    if input == "exit"
        puts "See you next time! ( ´ ▽ ` )"
    else
    call_city(input)
    end
end

def suitable_weather?(weather, temperature, humidity)
    if weather == "Clear" || weather == "Cloud" || weather == "Rain"
        if temperature > 55 && temperature < 85
            if humidity == nil
                true
            else
                humidity < 80 ? true : false
            end
        end
    else
        false
    end
end


def call_city(input)
    @city = City.new(input)
    if city.state == nil
        puts "That's not what I was That's not what I was made for |(￣3￣)|try again."
        self.call
    else
    weather_attributes = city.current_weather
    weather = weather_attributes["weather"]
    temperature = weather_attributes["temperature"]
    humidity = weather_attributes["humidity level"]
    puts " - The current weather of #{input} is #{weather}"
    puts " - The temperature is #{temperature}F, but it feels more like #{weather_attributes["feel like temperature"]}F"
    puts " - The lowest temperature of the day is #{weather_attributes["lowest temperature"]}F, and the highest temperature is #{weather_attributes["highest temperature"]}F"
    puts " - The humidity is #{humidity}%, and the wind is #{weather_attributes["wind speed"]}km/h"
    valid = suitable_weather?(weather, temperature, humidity)
    if  valid
        puts "The weather is good for hiking! Here is a list of national parks in the state:"
        self.choose_park
    else
        puts "The weather is terrible for hiking! I do not recommend to hike right now at this location"
        self.new_location
    end
    end
end

    def choose_park
        @city.parks_list.each_with_index do |park, index|
            puts "#{index + 1}. #{park}"
        end
        puts "   - Enter the park number to learn more about the park"
        puts "   - Or type 'back' to enter a new location"
        puts "   - To quit, type 'exit'"
        input2 = gets.strip
        if input2 == 'back'
            self.call
        elsif input2.to_i > 0 && input2.to_i <= @city.parks_list.length
            self.print_park(input2)
        elsif input2 == 'exit'
            puts "See you next time! ( ´ ▽ ` )"
        else
            puts "That's not what I was made for |(￣3￣)| Let's try again."
            self.choose_park
        end
    end

    def new_location
        puts "Please type 'back' to enter a new location"
        puts "To quit, type 'exit'"
        input2 = gets.strip
        if input2 == 'back'
            self.call
        elsif input2 == 'exit'
            puts "See you next time! ( ´ ▽ ` )"
        else 
        puts "That's not what I was made for |(￣3￣)| Let's try again."
        self.new_location
        end
    end


    def print_park(num)
        index = num.to_i - 1
        # binding.pry
        park_name = @city.state_park_names[index]
        park = Park.new(park_name)
        puts "#{park_name}"
        puts "- This park ranges over the following state(s) #{park.states}"
        puts "- Description:\n#{park.description}"
        puts "- Topics:\n#{park.topics.join(", ")}"
        puts "- Entrance Fee:\n#{park.entranceFees}"
        puts "- Standard Opening Hours:"
        park.standardHours.each do |k, v|
            puts "    #{k.capitalize}: #{v}"
        end
        puts "- Current Alerts:"
        if park.alert == []
            puts "    None"
        else
            park.alert.each do |alert|
            puts "  - Alert: #{alert[:title]}"
            puts "    #{alert[:description]}"
            puts "    Check out more at the website: #{alert[:url]}"
            end
        end

        puts "   - Type 'back' to choose a different park"
        puts "   - Or type 'city' to enter a new location"
        puts "   - To quit, type 'exit'"
        input3 = gets.strip
        if input3 == 'back'
            self.choose_park
        elsif input3 == 'city'
            self.call
        elsif input3 == 'exit'
            puts "See you next time! ( ´ ▽ ` )"
        else
            puts "That's not what I was made for |(￣3￣)| Let's try again."
            self.choose_park
        end
    end
end