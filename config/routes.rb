# frozen_string_literal: true

Socializer::Engine.routes.draw do
  post "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure", via: %i[get post]
  get "/signin", to: "sessions#new", as: :signin
  match "/signout", to: "sessions#destroy", as: :signout, via: %i[get delete]

  get "/activities/:id/comment", to: "comments#new", as: :comment_activity

  resources :activities, only: %i[index destroy] do
    resources :activities, only: [:index], controller: "activities/activities"

    member do
      # Audiences
      get "audience", to: "activities/audiences#index"

      # Likes
      get "likes", to: "activities/likes#index"
      post "like", to: "activities/likes#create"
      delete "unlike", to: "activities/likes#destroy"

      # Shares
      get "share", to: "activities/shares#new", as: "new_share"
      post "share", to: "activities/shares#create", as: "create_share"
    end
  end

  resources :audience_lists,  only: [:index]
  resources :authentications, only: %i[index destroy]

  resources :circles do
    resources :activities, only: [:index], controller: "circles/activities"

    collection do
      get "contacts", to: "circles/contacts#index"
      get "contact_of", to: "circles/contact_of#index"
      get "suggestions", to: "circles/suggestions#index"
    end
  end

  # Not a good idea to create comments that don"t belong to something else
  resources :comments, only: %i[new create edit update destroy]

  namespace :groups do
    get "joinable", to: "joinable#index"
    get "memberships", to: "memberships#index"
    get "ownerships", to: "ownerships#index"
    get "pending_invites", to: "pending_invites#index"
    get "public", to: "public#index"
    get "restricted", to: "restricted#index"
  end

  resources :groups do
    resources :activities, only: [:index], controller: "groups/activities"

    member do
      post "invite/:person_id", to: "groups/invitations#create", as: :invite_to
    end
  end

  resources :memberships, only: %i[create destroy] do
    member do
      post "confirm", to: "memberships/confirm#create"
      delete "decline", to: "memberships/decline#destroy"
    end
  end

  resources :notes, except: %i[index show]
  resources :notifications, only: %i[index show]

  # TODO: Enable shallow routes
  resources :people, only: %i[index show edit update] do
    resources :activities, only: [:index], controller: "people/activities"

    # TODO: Should these be nested under people since they act on current user?
    #       maybe namespace under profile?
    resources :person_addresses, except: %i[index show],
                                 controller: "people/addresses",
                                 path: "addresses"

    # TODO: See if this works with namespaced models
    # resources :addresses, except: %i[index show],
    #                       controller: "people/addresses"

    resources :person_contributions, except: %i[index show],
                                     controller: "people/contributions",
                                     path: "contributions"

    resources :person_educations, except: %i[index show],
                                  controller: "people/educations",
                                  path: "educations"

    resources :person_employments, except: %i[index show],
                                   controller: "people/employments",
                                   path: "employments"

    resources :person_links, except: %i[index show],
                             controller: "people/links",
                             path: "links"

    resources :person_phones, except: %i[index show],
                              controller: "people/phones",
                              path: "phones"

    resources :person_places, except: %i[index show],
                              controller: "people/places",
                              path: "places"

    resources :person_profiles, except: %i[index show],
                                controller: "people/profiles",
                                path: "profiles"

    member do
      get "likes", to: "people/likes#index"
      get "messages/new", to: "people/messages#new"
    end
  end

  resources :ties, only: %i[create destroy]

  # Reveal health status on /up that returns 200 if the app boots with no
  # exceptions, otherwise 500. Can be used by load balancers and uptime
  # monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Example root that gets defined for a logged in user
  # get "/",
  #     to: "activities#index",
  #     constraints: -> request { request.cookies.key?("user_id").present? }
  #
  root to: "pages#index"
end
