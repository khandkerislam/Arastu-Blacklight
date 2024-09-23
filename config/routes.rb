require 'sidekiq/web'

Rails.application.routes.draw do
  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new
  devise_for :users
  mount Blacklight::Engine => "/"

  mount Sidekiq::Web => '/sidekiq'
  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [ :index ], as: "catalog", path: "/catalog", controller: "catalog" do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [ :show ], path: "/catalog", controller: "catalog" do
    concerns [ :exportable, :marc_viewable ]
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete "clear"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
