class GithubAccount < ActiveRecord::Base
  belongs_to :user

  def self.create_from!(user, github_access_token_response, github_user_response)
    GithubAccount.create!({
      :user => user,
      :github_id => github_user_response["id"],
      :login => github_user_response["login"],
    }.merge(model_attributes_for(github_access_token_response)))
  end

  def update_authorization(github_access_token_response)
    update!(self.class.model_attributes_for(github_access_token_response))
  end

private

  def self.model_attributes_for(github_access_token_response)
    {
      :access_token => github_access_token_response["access_token"],
      :scopes => github_access_token_response["scope"].split(",")
    }
  end
end
