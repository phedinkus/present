Rails.application.routes.draw do
  get "authorizations/github", :to => "authorizations#github"
  get "authorizations/logout", :to => "authorizations#logout", :as => :logout

  get "weeks/current", :to => "weeks#current", :as => :current_week
  get "weeks/:year/:month/:day", :to => "weeks#show", :as => :show_week
  resources :weeks
  resources :timesheets, :path => "weeks", :controller => "weeks"

  get "invoices/todo", :to => "invoices#todo", :as => :todo_invoices
  get "invoices/todo/:year/:month/:day", :to => "invoices#todo", :as => :todo_invoices_ymd
  patch "invoices/send_to_harvest/:id", :to => "invoices#send_to_harvest", :as => :send_invoice_to_harvest
  resources :invoices

  resources :clients

  get "internal_notes", :to => "notes#internal", :as => :internal_notes
  resources :projects do
    get "notes/:year/:month/:day", :to => "notes#index", :as => :notes_for_week
    resources :notes
  end

  resources :users

  resources :impersonations

  post "entries/set_locations", :to => "entries#set_locations"

  resources :reports
  patch "pairings/user_settings", :to => "pairings#update_user_settings", :as => :pairing_settings #<-- why no work? Goes to pairings#update
  resources "accidental_pairings", :path => "pairings", :controller => "pairings"

  resources :missions
  resources :dossiers

  root "application#root"
end
