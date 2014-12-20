module Github
  class Api
    BASE_URL="https://api.github.com"

    def initialize(access_token)
      @access_token = access_token
      @connection = Faraday.new(:url => BASE_URL)
    end

    def user
      get('/user')
    end

    def test_double_agent?
      get('/user/orgs').any? do |org|
        if org.kind_of?(String)
          # the API just started spitting these out at some point I have no clue why
          org == "testdouble"
        else
          org["login"] == "testdouble"
        end
      end
    end

  private

    def get(url)
      JSON.parse(@connection.get(url, :access_token => @access_token).body)
    end
  end
end
