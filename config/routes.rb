Rails.application.routes.draw do
  get "authorizations/github", to: "authorizations#github"

  root "weeks#current"
end
