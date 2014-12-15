Socializer::Engine.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'sessions#failure', via: [:get, :post]
  match '/signin' => 'sessions#new', as: :signin,  via: :get
  match '/signout' => 'sessions#destroy', as: :signout, via: [:get, :delete]

  get '/stream' => 'activities#index', as: :stream

  scope '/stream' do
    get    '/activities/:id/audience' => 'activities#audience', as: :stream_audience
    get    '/activities/:id/likes' => 'likes#index', as: :stream_likes
    post   '/activities/:id/like' => 'likes#create', as: :stream_like
    delete '/activities/:id/unlike' => 'likes#destroy', as: :stream_unlike
    get    '/activities/:id/share' => 'shares#new', as: :new_stream_share
    post   '/activities/:id/share' => 'shares#create', as: :stream_shares
    get    '/activities/:id/comment' => 'comments#new', as: :stream_comment
  end

  scope '/memberships' do
    post '/:id/approve' => 'memberships#approve', as: :approve_membership
    get  '/:group_id/invite/:user_id' => 'memberships#invite', as: :invite_membership
    post '/:id/confirm' => 'memberships#confirm', as: :confirm_membership
    post '/:id/decline' => 'memberships#decline', as: :decline_membership
  end

  scope '/groups' do
    get '/public' => 'groups#public', as: 'groups_public'
    get '/restricted' => 'groups#restricted', as: 'groups_restricted'
    get '/joinable' => 'groups#joinable', as: 'groups_joinable'
    get '/memberships' => 'groups#memberships', as: 'groups_memberships'
    get '/ownerships' => 'groups#ownerships', as: 'groups_ownerships'
    get '/pending_invites' => 'groups#pending_invites', as: 'groups_pending_invites'
  end

  resources :activities,   only: [:index, :destroy] do
    resources :activities, only: [:index], controller: 'activities/activities'
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
  end

  resources :memberships,     only: [:create, :destroy]
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
