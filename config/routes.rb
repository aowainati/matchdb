Rails.application.routes.draw do
  root 'games#index'

  # TODO: games#show is the same as characters#index


  resources :games, only: [:index, :show] do
    resources :characters, only: [:index, :show]
    resources :matches, only: [:index, :show]
  end

  resources :players, only: [:index, :show]

  resources :events, only: [:index, :show]
end
