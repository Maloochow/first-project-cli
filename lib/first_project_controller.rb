require 'pry'
require_relative '../config/environment'

class Controller

attr_accessor :city

def call
    puts "Welcome to the Healthy Weather Station ٩( 'ω' )و"
    self.new_location
end

def new_location
    input_invalid = true
    until input_invalid == false
    puts "Please enter a city name from the U.S. to check local weather:"
    puts "(Type 'exit' to quit)"
    input = gets.strip.downcase
    if input == "exit"
        puts "See you next time! ( ´ ▽ ` )"
        input_invalid = false
    else
        @city = City.new(name: input)
        if city == nil
        puts "That's not what I was made for |(￣3￣)| let's try again."
        else
        self.call_city
        input_invalid = false
        end
    end
    end
end

def suitable_weather?(weather, temperature, humidity)
    # if weather == "Clear" || weather == "Cloud" || weather == "Rain"
        if temperature > 54 && temperature < 86
            if humidity == nil
                true
            else
                humidity < 80 ? true : false
            end
        else
            false
        end
end

def city_array?
    city_o = city.city_o
    if city_o.class == Array
        puts "There are multiple cities under this name _φ(･_･"
        city_o.each_with_index do |c, i|
            puts "#{i + 1}. #{c["name"]}, #{c["state"]}"
        end
        input_invalid = true
        until input_invalid == false
        puts "Please enter the city number to check the current weather:"
        puts "(Type 'back' to enter a different city)"
        input = gets.strip.downcase
        if input == "back"
            self.new_location
            input_invalid = false
        elsif input.to_i > 0 && input.to_i <= city_o.length
            city_name = city_o[input.to_i - 1]["name"]
            city_state = city_o[input.to_i - 1]["state"]
            @city = City.create(city_name, city_state)
            input_invalid = false
        else
            puts "That's not what I was made for |(￣3￣)| let's try again."
        end
        end
    else
        nil
    end
end


def call_city
    self.city_array?
    weather_attributes = city.current_weather
    weather = weather_attributes["weather"]
    temperature = weather_attributes["temperature"]
    humidity = weather_attributes["humidity level"]
    puts " - The current weather of #{city.name}, #{city.state} is #{weather}"
    puts " - The temperature is #{temperature}F, but it feels more like #{weather_attributes["feel like temperature"]}F"
    puts " - The lowest temperature of the day is #{weather_attributes["lowest temperature"]}F, and the highest temperature is #{weather_attributes["highest temperature"]}F"
    puts " - The humidity is #{humidity}%, and the wind is #{weather_attributes["wind speed"]}km/h"
    valid = suitable_weather?(weather, temperature, humidity)
    if  valid
        puts "The weather is good for hiking! Here is a list of national parks in the state:"
        city.create_parks_list
        self.choose_park
    else
        puts "The weather is terrible for hiking! (＞人＜;) I don't recommend hiking right now at this location"
        self.new_location
    end
end



def choose_park
    city.state_park_names.each_with_index do |park, index|
        puts "#{index + 1}. #{park}"
    end
    input_invalid = true
    until input_invalid == false
    puts "   - Enter the park number to learn more about the park"
    puts "   - Or type 'back' to enter a new location"
    puts "   - To quit, type 'exit'"
    input2 = gets.strip.downcase
    if input2 == 'back'
        self.new_location
        input_invalid = false
    elsif input2.to_i > 0 && input2.to_i <= city.state_park_names.length
        self.print_park(input2)
        input_invalid = false
    elsif input2 == 'exit'
        puts "See you next time! ( ´ ▽ ` )"
        input_invalid = false
    else
        puts "That's not what I was made for |(￣3￣)| Let's try again."
    end
end
end

    # def new_location
    #     puts "Please type 'back' to enter a new location"
    #     puts "To quit, type 'exit'"
    #     input2 = gets.strip
    #     if input2 == 'back'
    #         self.call
    #     elsif input2 == 'exit'
    #         puts "See you next time! ( ´ ▽ ` )"
    #     else 
    #     puts "That's not what I was made for |(￣3￣)| Let's try again."
    #     self.new_location
    #     end
    # end


    def print_park(num)
        index = num.to_i - 1
        # binding.pry
        park_name = city.state_park_names[index]
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
        if park.alert[:title] == ""
            puts "    None"
        else
            puts "  - Alert: #{park.alert[:title]}"
            puts "    #{park.alert[:description]}"
            puts "    Check out more at the website: #{park.alert[:url]}"
        end

        input_invalid = true
        until input_invalid == false
        puts "   - Type 'back' to choose a different park"
        puts "   - Or type 'city' to enter a new location"
        puts "   - To quit, type 'exit'"
        input3 = gets.strip.downcase
        if input3 == 'back'
            self.choose_park
            input_invalid = false
        elsif input3 == 'city'
            self.new_location
            input_invalid = false
        elsif input3 == 'exit'
            puts "See you next time! ( ´ ▽ ` )"
            input_invalid = false
        else
            puts "That's not what I was made for |(￣3￣)| Let's try again."
        end
        end
    end
end