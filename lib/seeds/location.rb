module Seeds
  module Location
    def self.seed!
      [
        {:city => "Oakland", :state => "CA" },
        {:city => "Denver", :state => "CO" },
        {:city => "Broomfield", :state => "CO" },
        {:city => "Yorktown", :state => "IN" },
        {:city => "Chicago", :state => "IL" },
        {:city => "Louisville", :state => "KY" },
        {:city => "Detroit", :state => "MI" },
        {:city => "Grand Rapids", :state => "MI" },
        {:city => "Columbus", :state => "OH" },
        {:city => "Westerville", :state => "OH" },
        {:city => "Powell", :state => "OH" },
        {:city => "Hilliard", :state => "OH" },
        {:city => "Johnstown", :state => "OH" },
        {:city => "Hayesville", :state => "OR"},
        {:city => "Jonestown", :state => "PA" },
        {:city => "Salt Lake City", :state => "UT" },
        {:city => "Virginia Beach", :state => "VA" },
        {:city => "Madison", :state => "WI" },
        {:city => "Ottawa", :state => "ON" },
        {:city => "Saskatoon", :state => "SK" },
        {:city => "Box Elder", :state => "SD" },
      ].each do |location|
        ::Location.find_or_create_by!(
          :city => location[:city],
          :state => location[:state]
        )
      end
    end
  end
end
