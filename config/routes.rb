Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'sessions/new'

  # namespaceはURL改装、モジュール、URLパターン名に一括で一定の制約をかける。
  # 以下はAdmin::UsersControllerのCRUDを、/admin/usersといったURL, admin_users_pathといったURLヘルパーメソッドとともに実現
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks

  # indexだけのルート
  # resources :tasks, only [:index]
  #
  # destroy, edit, update以外の４つのアクション
  # resources :tasks, except: [:delete, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
