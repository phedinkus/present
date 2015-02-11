module Github
  module OAuth
    BASE_URL="https://github.com/login/oauth"

    def self.login_url_for_state(state)
      "#{BASE_URL}/authorize?" + {
        :client_id => Rails.application.config.github.client_id,
        :state => state,
        :scope => "read:org"
      }.to_param
    end

    def self.request_access_token_for_code(code)
      JSON.parse(Faraday.new(:url => "#{BASE_URL}/access_token").post do |req|
        req.params = {
          :client_id => Rails.application.config.github.client_id,
          :client_secret => Rails.application.secrets.github_client_secret,
          :code => code
        }
        req.headers["Accept"] = "application/json"
      end.body)
    end
  end
end
