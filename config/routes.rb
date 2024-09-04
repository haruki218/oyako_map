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
    root to: 'homes#top'
    resources :users, only: [:index, :show, :destroy]
    resources :posts
    resources :tags, only: [:index, :create, :destroy]
  end

  # パブリック側
  root to: 'public/homes#top'
  get '/main', to: 'public/homes#main', as: 'main_page'
  get '/mypage', to: 'public/users#mypage', as: 'mypage'
  resources :users, only: [:edit, :show, :update, :destroy], controller: 'public/users'
  resources :posts, controller: 'public/posts' do
    resources :comments, only: [:create, :destroy], controller: 'public/comments'
    resources :ratings, only: [:create], controller: 'public/ratings'
  end
  resources :tags, only: [:create, :destroy], controller: 'public/tags'
  get '/search', to: 'public/search#index', as: 'search'
  get '/maps/:prefecture_name', to: 'public/maps#show', as: 'map'
  
  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  
end
