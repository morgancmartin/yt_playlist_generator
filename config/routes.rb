Rails.application.routes.draw do
  root 'playlists#index'
  resources :playlists

  get 'oauth' => 'playlists#oauth'
  get 'reset' => 'playlists#reset'
end
