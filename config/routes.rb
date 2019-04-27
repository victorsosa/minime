# frozen_string_literal: true

Rails.application.routes.draw do
  resources :links
  # get ':url', to: 'links#generateShortUrl'
  get '(/:in_url)' => 'links#go'
  get '/top', to: 'links#top'
end
