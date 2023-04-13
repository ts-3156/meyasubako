Rails.application.routes.draw do
  root "home#index"

  get "forms", to: "forms#index"
  get "forms/:survey_token/edit", to: "forms#edit", as: :form
  post "forms/:survey_token/responses", to: "survey_responses#create", as: :form_responses

  resources :surveys, only: [:index, :new, :edit, :create, :update]
  get "surveys/:id/responses", to: "surveys#responses", as: :survey_responses
  get "surveys/:id/download", to: "surveys#download", as: :survey_download

  get "login", to: "sessions#new"
  post "sessions", to: "sessions#create"
  get "logout", to: "sessions#destroy"

  namespace :api, {format: "json"} do
    post "surveys/:id", to: "surveys#update", as: :survey
    get "survey_responses", to: "survey_responses#index"
  end
end
