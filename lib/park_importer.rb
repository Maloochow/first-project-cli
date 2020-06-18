require 'pry'
require 'rest-client'
require 'json'

module ParkImporter


    BASE_URL = 'https://developer.nps.gov/api/v1/parks'
    ALERT_URL = 'https://developer.nps.gov/api/v1/alerts'
 
    
    def parks_by_state(state_code:)
        url = BASE_URL + "?stateCode=#{state_code}"
        @@state_parks = park_hash(url)
        # parklist = @@state_parks["data"].select {|park| park["states"] == state_code}
        # parklist["total"]
        # binding.pry
        @@state_park_names = @@state_parks["data"].map do |park|
            park["fullName"]
        end
    end

    def state_park_names
        @@state_park_names
    end
    
    def park_info(parkname)
        hash = get_park_hash(parkname)
        park_code = hash["parkCode"]
        alert = get_park_alert(park_code)
        park_info_hash = {}
        park_info_hash["alert"] = []
        if alert == nil
            park_info_hash["alert"]
        else
            alert["data"][0].each do |hash|
                park_info_hash["alert"] << {title: hash["title"], description: hash["description"], url: hash["url"]}
            end
        end
        park_info_hash["name"] = hash["fulName"]
        park_info_hash["states"] = hash["states"]
        park_info_hash["description"] = hash["description"]
        park_info_hash["topics"] = hash["topics"].map {|i| i["name"]}
        park_info_hash["entranceFees"] = hash["entranceFees"][0]["description"]
        park_info_hash["standardHours"] = hash["operatingHours"][0]["standardHours"]
        park_info_hash
    end

    def get_park_hash(parkname)
        park_o = @@state_parks["data"].find {|park| park["fullName"] == parkname}
    end

    def get_park_alert(park_code)
        # alerts = self.park_alert_hash
        # park_o = get_park_hash(parkname)
        url_alert = ALERT_URL + "?parkCode=#{park_code}"
        park_alert_hash(url_alert)[0]
    end

    def park_hash(url)
    response = RestClient::Request.execute(
        method:   :get,
        url:       url,
        headers:   {'X-Api-Key': 'BweVtjeqnX4rjRIEaUVgld1wx2X7V1fx7JEBreeb'}
    )
    @@parks_hash = JSON.parse(response)
    end

    def park_alert_hash(url)
    response = RestClient::Request.execute(
        method:   :get,
        url:       url,
        headers:   {'X-Api-Key': 'BweVtjeqnX4rjRIEaUVgld1wx2X7V1fx7JEBreeb'}
    )
    @@parks_alert_hash = JSON.parse(response)
    end
end





# URL = "https://developer.nps.gov/api/v1/parks?parkCode=acad&api_key=BweVtjeqnX4rjRIEaUVgld1wx2X7V1fx7JEBreeb"
# BASE_URL = 'https://developer.nps.gov/api/v1/parks?parkCode=acad'