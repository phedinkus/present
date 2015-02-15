require "test_helper"

describe "Smoke", :capybara do
  Given { visit root_path }
  Given { login_to_github }
  Then { page.has_content?("Welcome, Do U. Bot!") }
end


def login_to_github
  fill_in "Username or Email", :with => ENV['PRESENT_TEST_GITHUB_ID']
  fill_in "Password", :with => ENV['PRESENT_TEST_GITHUB_PASSWORD']
  click_button "Sign in"
end
