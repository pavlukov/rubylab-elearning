# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  root 'home#index'

  get 'search', to: 'search#index', as: 'search'
  post 'search', to: 'search#search'
  post 'user_dashboard_search', to: 'search#user_dashboard_search'

  authenticate :user, lambda(&:admin) do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users,
             path: 'auth',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               password: 'secret',
               confirmation: 'verification',
               unlock: 'unblock',
               registration: 'register',
               sign_up: 'sign_up'
             },
             controllers: {
               sessions: 'users/sessions',
               # omniauth_callbacks: 'users/omniauth_callbacks',
               unlocks: 'users/unlocks',
               registrations: 'users/registrations',
               passwords: 'users/passwords',
               confirmations: 'users/confirmations'
             }
  devise_scope :user do
    patch '/auth/verification', to: 'users/confirmations#update', as: :update_user_confirmation
  end

  resources :organizations do
    member do
      # user actions for organizations
      delete '/leave', to: 'organizations#leave', as: :leave
      # org_admin actions for organizations
      scope :manage do
        get '/', to: 'organization_dashboard#index', as: :home_dashboard
        scope :requests do
          get '/', to: 'organizations/join_requests#index', as: :requests
          post '/', to: 'organizations/join_requests#create', as: :create_request
          get '/:join_request_id/specify', to: 'organizations/join_requests#specify_reason', as: :specify_reason_request
          put '/:join_request_id/accept', to: 'organizations/join_requests#accept', as: :accept_request
          put '/:join_request_id/decline', to: 'organizations/join_requests#decline', as: :decline_request
          delete '/:join_request_id', to: 'organizations/join_requests#destroy', as: :destroy_request
        end
        scope :invites do
          get '/', to: 'organizations/invites#index', as: :invites
          post '/', to: 'organizations/invites#create', as: :create_invite
          post '/import', to: 'organizations/invites#import', as: :import
          delete '/:invite_id', to: 'organizations/invites#destroy', as: :destroy_invite
        end
        scope :reports do
          get '/', to: 'reports#index', as: :reports
        end
        get '/memberships', to: 'memberships#index', as: :memberships
        delete '/memberships/:membership_id', to: 'memberships#destroy', as: :destroy_membership
      end
    end
  end
  get '/questions', to: 'questions#new', as: :questions
  post '/questions/create', to: 'questions#create', as: :add_question
  post '/questions/add', to: 'questions#render_form', as: :render_question_form
  delete '/questions/:question_id/destroy', to: 'questions#destroy', as: :destroy_question

  get '/organization/sortable', to: 'organizations#sortable', as: :organizations_sortable

  resources :courses do
    member do
      get '/pages', to: 'pages#index', as: :pages
      post '/pages', to: 'pages#create'
      get '/pages/new', to: 'pages#new', as: :new_page
      get '/pages/:page_id/edit', to: 'pages#edit', as: :edit_page
      get '/pages/:page_id', to: 'pages#show', as: :page
      patch '/pages/:page_id', to: 'pages#update'
      delete '/pages/:page_id', to: 'pages#destroy'
      post '/pages/:page_id/user_answers', to: 'user_answers#store', as: :store_answers
      get '/check', to: 'check#index', as: :check
      get '/check/:user_id', to: 'check#show', as: :user_check
      post '/check/:user_id/grade', to: 'check#grade', as: :user_grade
      post '/finish', to: 'check#finish', as: :finish
    end
  end

  post '/courses/:id/add_favorite', to: 'favorite_courses#create', as: :add_favorite_course
  delete '/courses/:id/remove_favorite', to: 'favorite_courses#destroy', as: :remove_favorite_course
  post '/courses/:id/enroll', to: 'participations#create', as: :create_participation
  patch '/courses/:id/publish', to: 'courses#publish', as: :publish_course
  patch '/courses/:id/archive', to: 'courses#archive', as: :archive_course
  get '/course/sortable', to: 'courses#sortable', as: :courses_sortable
  patch '/courses/:id/rate', to: 'courses#rate', as: :rate_course
  scope :user do
    post '/impersonate/:id', to: 'impersonization#impersonate', as: :impersonate
    post '/stop_impersonating/:id', to: 'impersonization#stop_impersonating', as: :stop_impersonating
    get '/', to: 'user_dashboard#index', as: :user_dashboard
    resource :profile, only: %i[show edit update]
    resources :participations, only: %i[index destroy]
    resources :certificates, only: %i[index show]
    scope :invites do
      get '/', to: 'users/invites#index', as: :invites_user
      put '/:invite_id/accept', to: 'users/invites#accept', as: :accept_invite_user
      put '/:invite_id/decline', to: 'users/invites#decline', as: :decline_invite_user
    end
    get '/requests', to: 'users/join_requests#index', as: :requests_history
    delete '/requests/:join_request_id', to: 'users/join_requests#destroy', as: :cancel_request
  end
end
