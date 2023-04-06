Rails.application.routes.draw do
  root "home#index"
  get "forms/:survey_token/edit", to: "forms#edit", as: :form
  get "forms/:survey_token/responses", to: "forms#responses", as: :form_responses
  get "forms/:survey_token/download", to: "forms#download", as: :form_download
  post "survey_responses", to: "survey_responses#create"
  get "login", to: "sessions#new"
  post "sessions", to: "sessions#create"
  get "logout", to: "sessions#destroy"
  resources :surveys, only: [:index, :new, :create]

  namespace :api, {format: "json"} do
    post :surveys, to: "surveys#update"
  end
end
