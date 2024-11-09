require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users
  mount Sidekiq::Web => "/sidekiq"

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], controller: 'catalog' do
    concerns :searchable
  end
  
  root to: "home#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end