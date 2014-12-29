Socializer::Engine.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'sessions#failure', via: [:get, :post]
  match '/signin' => 'sessions#new', as: :signin,  via: :get
  match '/signout' => 'sessions#destroy', as: :signout, via: [:get, :delete]

  get '/stream' => 'activities#index', as: :stream

  scope '/stream' do
    get    '/activities/:id/likes' => 'likes#index', as: :stream_likes
    post   '/activities/:id/like' => 'likes#create', as: :stream_like
    delete '/activities/:id/unlike' => 'likes#destroy', as: :stream_unlike
    get    '/activities/:id/share' => 'shares#new', as: :new_stream_share
    post   '/activities/:id/share' => 'shares#create', as: :stream_shares
    get    '/activities/:id/comment' => 'comments#new', as: :stream_comment
  end

  resources :activities,   only: [:index, :destroy] do
    resources :activities, only: [:index], controller: 'activities/activities'

    # TODO: For single action prefer this or resources with only?
    member do
      get 'audience' => 'activities/audiences#index'
    end
  end

  resources :audiences,       only: [:index]
  resources :authentications, only: [:index, :show, :new, :destroy]

  resources :circles do
    resources :activities, only: [:index], controller: 'circles/activities'

    collection do
      get 'contacts'
      get 'contact_of'
      get 'find_people'
    end
  end

  resources :comments,        only: [:new, :create, :edit, :update, :destroy]

  resources :groups do
    resources :activities, only: [:index], controller: 'groups/activities'

    collection do
      get 'joinable'
      get 'memberships'
      get 'ownerships'
      get 'pending_invites'
      get 'public'
      get 'restricted'
    end

    member do
      post 'invite/:user_id' => 'groups#invite', as: :invite_to
    end
  end

  resources :memberships,     only: [:create, :destroy] do
    member do
      post 'approve', as: :approve
      post 'confirm', as: :confirm
      post 'decline', as: :decline
    end
  end

  resources :notes
  resources :notifications,   only: [:index, :show]

  resources :people,          only: [:index, :show, :edit, :update] do
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

  resources :ties,            only: [:create, :destroy]

  root to: 'pages#index'
end
