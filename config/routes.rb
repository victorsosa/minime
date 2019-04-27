# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :links
  post 'url', to: 'links#generate_short_url'
  get 'top', to: 'links#top'
  get ':in_url' => 'links#go'
end
