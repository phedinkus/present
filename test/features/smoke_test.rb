require "test_helper"

describe "Smoke", :capybara do
  Given { visit root_path }
  When { all('a') }
  Then {
    binding.pry
    page.must_not_have_content "HELLO" }
end
