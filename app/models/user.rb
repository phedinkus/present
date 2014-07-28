class User < ActiveRecord::Base
  has_one :github_account

  def self.user_for(session_token)
    find_by(:session_token => session_token)
  end
end
