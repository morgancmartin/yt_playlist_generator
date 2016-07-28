Rails.application.routes.draw do
  # root 'playlists#new'
  resources :playlists

  get 'oauth' => 'playlists#oauth'
  get 'reset' => 'playlists#reset'
end
