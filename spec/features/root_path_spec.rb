require 'spec_helper'

describe 'the root path of the webapp' do
  Given!(:user) {
    User.create!(
      :id => 1,
      :name => "Joe Schmoe",
      :github_account => GithubAccount.new(
        :github_id => 1337,
        :login => "joe",
        :access_token => "not-a-real-access-token",
        :scopes => []
      )
    )
  }
  Then { expect(page).to have_content("8/17/14") }
end
