Rails.application.routes.draw do
  get "authorizations/github", :to => "authorizations#github"

  get "weeks/:year/:ordinal", :to => "weeks#show"

  root "weeks#current"
end
