module Github
  module Api
    BASE_URL="https://api.github.com"

    def self.user_for_access_token(access_token)
      JSON.parse(Faraday.new(:url => BASE_URL).get('/user', :access_token => access_token).body)
    end
  end
end
