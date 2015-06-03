source 'https://rubygems.org'
if ENV['DYNO']
  ruby '2.2.0'
else
  raise 'Ruby version must be >= than 2.1' unless  RUBY_VERSION.to_f >= 2.1
end

gem 'dotenv-rails', :groups => [:development, :test]

gem 'rails', '4.2'
gem 'pg'

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'raygun4ruby'
end

gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

gem 'faraday'
gem 'harvested'

group :development, :test do
  gem 'pry-rails'
  gem 'spring'
  gem 'awesome_print'
  gem 'web-console'

  gem 'minitest-rails'
  gem 'minitest-given'
  gem 'minitest-rails-capybara'
  gem 'selenium-webdriver'
  gem 'poltergeist'
end

group :development do
  gem 'query_diet'
  gem 'bullet'
end

group :test do
  gem "codeclimate-test-reporter", :require => false
end
