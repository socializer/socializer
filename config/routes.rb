Socializer::Engine.routes.draw do

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  
  match '/stream(/:provider/:id)' => 'activities#index', :as => :stream
  match '/stream/activities/:id/audience' => 'activities#audience', :as => :stream_audience
  match '/stream/activities/:id/likes' => 'activities#likes', :as => :stream_likes
  match '/stream/activities/:id/like' => 'activities#like', :as => :stream_like
  match '/stream/activities/:id/unlike' => 'activities#unlike', :as => :stream_unlike
  match '/stream/activities/:id/share' => 'activities#new_share', :as => :stream_share, :via => :get
  match '/stream/activities/:id/share' => 'activities#share', :as => :stream_share, :via => :post
  match '/stream/activities/:id/comment' => 'comments#new', :as => :stream_comment
  
  match '/memberships/:id/approve' => 'memberships#approve', :as => :approve_membership
  match '/memberships/:group_id/invite/:user_id' => 'memberships#invite', :as => :invite_membership
  match '/memberships/:id/confirm' => 'memberships#confirm', :as => :confirm_membership

  match '/people/:id/likes' => 'people#likes', :as => :person_likes
  match '/people/:id/message' => 'people#message', :as => :person_message
  
  match '/circles/contacts' => 'circles#contacts', :as => :circles_contacts
  match '/circles/contact_of' => 'circles#contact_of', :as => :circles_contact_of
  match '/circles/find_people' => 'circles#find_people', :as => :circles_find_people
  
  match '/groups/memberships' => 'groups#memberships', :as => :groups_memberships
  match '/groups/ownerships' => 'groups#ownerships', :as => :groups_ownerships
  match '/groups/pending_invites' => 'groups#pending_invites', :as => :groups_pending_invites

  resources :authentications, :only => [ :index, :show, :new, :destroy ]
  resources :people,          :only => [ :index, :show, :edit, :update ]
  resources :notes,           :only => [ :index, :show, :new, :create, :edit, :update, :destroy ]
  resources :circles,         :only => [ :index, :show, :new, :create, :edit, :update, :destroy ]
  resources :activities,      :only => [ :index, :destroy ]    
  resources :comments,        :only => [ :new, :create, :edit, :update, :destroy ]
  resources :groups,          :only => [ :index, :show, :new, :create, :edit, :update, :destroy ]
  resources :memberships,     :only => [ :create, :destroy ]
  resources :ties,            :only => [ :create, :destroy ]
  resources :notifications,   :only => [ :index ]
  
  resources :audiences,       :only => [ :index ]
  
  root :to => "pages#index"

end
