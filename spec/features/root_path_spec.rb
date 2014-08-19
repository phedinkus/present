require 'spec_helper'

describe 'the root path of the webapp' do
  Given {
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
  Given {
    Project.create!(
      :name => "Some Project",
      :active => true,
      :client => Client.new(:name => "Acme", :active => true)
    )
  }

  Given { visit('/') }

  Given(:project_rows) { all('.timesheet-form table tbody tr') }

  context 'initial state' do
    Then { project_rows.size == 2 }
    And { project_rows[0].all('td').first.text == "Vacation" }
    And { project_rows[1].all('td').first.text == "Holiday" }
  end

  context 'after adding a project' do
    When { click_button "Add Project" }
    When(:first_row_text) { project_rows[0].all('td').first.text }
    Then { project_rows.size == 3 }
    And { expect(first_row_text).to include("Some Project") }
    And { expect(first_row_text).to include("Acme") }
  end

end
