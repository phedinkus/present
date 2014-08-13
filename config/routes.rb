Rails.application.routes.draw do
  get "authorizations/github", :to => "authorizations#github"
  get "authorizations/logout", :to => "authorizations#logout", :as => :logout

  get "weeks/current", :to => "weeks#current", :as => :current_week
  get "weeks/:year/:month/:day", :to => "weeks#show", :as => :show_week
  resources :weeks
  resources :timesheets, :path => "weeks", :controller => "weeks"

  get "invoices/todo", :to => "invoices#todo", :as => :todo_invoices
  patch "invoices/send_to_harvest/:id", :to => "invoices#send_to_harvest", :as => :send_invoice_to_harvest
  resources :invoices

  resources :impersonations


  root "application#root"
end
