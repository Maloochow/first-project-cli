require_relative './park_importer'

class Park
include ParkImporter
attr_reader :alert, :name, :states, :description, :topics, :entranceFees, :standardHours
@@all = []

def initialize(parkname)
    hash = park_info(parkname)
    @alert = hash["alert"]
    @name = hash["name"]
    @states = hash["states"]
    @description = hash["description"]
    @topics = hash["topics"]
    @entranceFees = hash["entranceFees"]
    @standardHours = hash["standardHours"]
    @@all << self
end


end