class Location < ActiveRecord::Base
  default_scope ->{ order('state, city') }
  def to_s
    "#{city}, #{state}"
  end
end
