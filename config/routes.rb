Rails.application.routes.draw do
  root 'playlists#index'
  resources :playlists

  get 'oauth' => 'playlists#oauth'
  get 'reset' => 'playlists#reset'
  get 'delete_user_playlists' => 'playlists#delete_user_playlists'
end
