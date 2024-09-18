Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者側
  namespace :admin do
    root to: 'posts#index'
    resources :users, only: [:index, :show, :destroy]
    resources :posts, only: [:show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy]
    end
    resources :tags, only: [:show, :index, :create, :destroy]
    get '/search', to: 'search#index', as: 'search'
  end

  # パブリック側
  root to: 'public/homes#top'
  get '/main', to: 'public/homes#main', as: 'main_page'
  get '/mypage', to: 'public/users#mypage', as: 'mypage'
  resources :users, only: [:edit, :show, :update, :destroy], controller: 'public/users' do
    get 'posts', to: 'public/users#posts', as: 'posts'
  end
  resources :posts, controller: 'public/posts' do
    collection do
      get 'new_play', to: 'public/posts#new_play'
      get 'new_facility', to: 'public/posts#new_facility'
    end
    resources :comments, only: [:create, :destroy], controller: 'public/comments'
    resources :ratings, only: [:create], controller: 'public/ratings'
  end
  resources :tags, only: [:show, :create, :destroy], controller: 'public/tags'
  get '/search', to: 'public/search#index', as: 'search'
  get '/maps/:prefecture_name', to: 'public/maps#show', as: 'map'
  
  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  
end
