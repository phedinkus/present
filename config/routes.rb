Rails.application.routes.draw do
  get "authorizations/github", :to => "authorizations#github"
  get "authorizations/logout", :to => "authorizations#logout", :as => :logout

  get "weeks/current", :to => "weeks#current", :as => :current_week
  get "weeks/:year/:month/:day", :to => "weeks#show", :as => :show_week
  resources :weeks

  resources :timesheets, :path => "weeks", :controller => "weeks"

  root "application#root"
end
