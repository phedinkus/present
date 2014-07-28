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
      get('/user/orgs').any? { |org| org["login"] == "testdouble" }
    end

  private

    def get(url)
      JSON.parse(@connection.get(url, :access_token => @access_token).body)
    end
  end
end
