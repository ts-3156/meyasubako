Rails.application.routes.draw do
  root "home#index"
  get "forms/:survey_token/edit", to: "forms#edit", as: :form
  get "forms/:survey_token/responses", to: "forms#responses", as: :form_responses
  get "forms/:survey_token/download", to: "forms#download", as: :form_download
  post "survey_responses", to: "survey_responses#create"
end
