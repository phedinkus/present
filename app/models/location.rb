class Location < ActiveRecord::Base
  def to_s
    "#{city}, #{state}"
  end
end
