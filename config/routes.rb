Socializer::Engine.routes.draw do

  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'sessions#failure', via: [:get, :post]
  match '/signin' => 'sessions#new', as: :signin,  via: :get
  match '/signout' => 'sessions#destroy', as: :signout, via: [:get, :delete]

  scope '/stream' do
    get    '(/:provider/:id)' => 'activities#index', as: :stream
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

  scope '/people' do
    get '/:id/likes' => 'people#likes', as: :person_likes
    # get '/:person_id/likes' => 'likes#index', as: :person_likes
    get '/:id/message' => 'people#message', as: :person_message
  end

  scope '/circles' do
    get '/contacts' => 'circles#contacts', as: :circles_contacts
    get '/contact_of' => 'circles#contact_of', as: :circles_contact_of
    get '/find_people' => 'circles#find_people', as: :circles_find_people
  end

  scope '/groups' do
    get '/public' => 'groups#public', as: 'groups_public'
    get '/restricted' => 'groups#restricted', as: 'groups_restricted'
    get '/joinable' => 'groups#joinable', as: 'groups_joinable'
    get '/memberships' => 'groups#memberships', as: 'groups_memberships'
    get '/ownerships' => 'groups#ownerships', as: 'groups_ownerships'
    get '/pending_invites' => 'groups#pending_invites', as: 'groups_pending_invites'
  end

  resources :authentications, only: [:index, :show, :new, :destroy]
  resources :people,          only: [:index, :show, :edit, :update]
  resources :notes,           only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :circles,         only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :activities,      only: [:index, :destroy]
  resources :comments,        only: [:new, :create, :edit, :update, :destroy]
  resources :groups,          only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :memberships,     only: [:create, :destroy]
  resources :ties,            only: [:create, :destroy]
  resources :notifications,   only: [:index, :show]

  resources :audiences,       only: [:index]

  root to: 'pages#index'

end
