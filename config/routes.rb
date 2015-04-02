Socializer::Engine.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'sessions#failure', via: [:get, :post]
  match '/signin' => 'sessions#new', as: :signin,  via: :get
  match '/signout' => 'sessions#destroy', as: :signout, via: [:get, :delete]

  get '/activities/:id/comment' => 'comments#new', as: :comment_activity

  resources :activities, only: [:index, :destroy] do
    resources :activities, only: [:index], controller: 'activities/activities'

    member do
      # Audiences
      get 'audience' => 'activities/audiences#index'

      # Likes
      get 'likes' => 'activities/likes#index'
      post 'like' => 'activities/likes#create'
      delete 'unlike' => 'activities/likes#destroy'

      # Shares
      get 'share' => 'activities/shares#new', as: 'new_share'
      post 'share' => 'activities/shares#create', as: 'create_share'
    end
  end

  resources :audience_lists,  only: [:index]
  resources :authentications, only: [:index, :show, :new, :destroy]

  resources :circles do
    resources :activities, only: [:index], controller: 'circles/activities'

    collection do
      get 'contacts'
      get 'contact_of'
      get 'find_people'
    end
  end

  # Not a good idea to create comments that don't belong to something else
  resources :comments, only: [:new, :create, :edit, :update, :destroy]

  namespace :groups do
    get 'joinable', to: 'joinable#index'
    get 'memberships', to: 'memberships#index'
    get 'ownerships', to: 'ownerships#index'
    get 'pending_invites'
    get 'public'
    get 'restricted'
  end

  resources :groups do
    resources :activities, only: [:index], controller: 'groups/activities'

    member do
      get 'invite/:user_id' => 'groups#invite', as: :invite_to
    end
  end

  resources :memberships, only: [:create, :destroy] do
    member do
      post 'approve', as: :approve
      post 'confirm', as: :confirm
      post 'decline', as: :decline
    end
  end

  resources :notes
  resources :notifications, only: [:index, :show]

  resources :people, only: [:index, :show, :edit, :update] do
    resources :activities,     only: [:index], controller: 'people/activities'
    resources :addresses,      only: [:create, :update, :destroy], controller: 'people/addresses'
    resources :contributions,  only: [:create, :update, :destroy], controller: 'people/contributions'
    resources :educations,     only: [:create, :update, :destroy], controller: 'people/educations'
    resources :employments,    only: [:create, :update, :destroy], controller: 'people/employments'
    resources :links,          only: [:create, :update, :destroy], controller: 'people/links'
    resources :phones,         only: [:create, :update, :destroy], controller: 'people/phones'
    resources :places,         only: [:create, :update, :destroy], controller: 'people/places'
    resources :profiles,       only: [:create, :update, :destroy], controller: 'people/profiles'

    member do
      get 'likes'
      get 'message'
    end
  end

  resources :ties, only: [:create, :destroy]

  # Example root that gets defined for a logged in user
  # get '/' => 'activities#index', constraints: -> request { request.cookies.key?('user_id').present? }
  root to: 'pages#index'
end
