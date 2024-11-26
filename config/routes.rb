Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    root :to => "posts#index"
    get "about" => "homes#about"
    get "my_page" => "users#my_page"
    get "search" => "searches#search"
    get "search_page" => "searches#search_page"
    get "my_favorite" => "users#my_favorite"
    get 'users' => 'users#dummy' # 新規登録画面で登録失敗した際にURLが/usersとなり、リロードするとRouting Errorが表示されてしまうため、controller側で redirect_to new_user_registration_path を用意している
    resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy] do
      resource :favorites, only: [:create, :destroy] do
        get 'favorite_users' => 'favorites#favorite_users', as: 'favorite_users'
      end
      resources :post_comments, only: [:create, :destroy]
      get 'post_comment_users' => 'post_comments#post_comment_users', as: 'post_comment_users'
    end
    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    resources :rooms, only: [:index, :create, :show] do
      resources :messages, only: [:create, :destroy]
    end
    resources :notifications, only: [] do
      collection do
        patch :mark_as_read # 通知確認ボタンの処理
        get 'more', to: 'notifications#more_notifications' # 通知欄にある"さらに読み込む"ボタンの非同期通信のため
      end
    end
  end

  namespace :admin do
    root :to => "inquiries#index"
    resources :users do
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      get "user_favorite" => "users#user_favorite"
    end
    resources :emotions
    resources :posts do
      resource :favorites, only: [] do
        get 'favorite_users' => 'favorites#favorite_users', as: 'favorite_users'
      end
      resources :post_comments, only: [:destroy]
      get 'post_comment_users' => 'post_comments#post_comment_users', as: 'post_comment_users'
    end
    resources :inquiries
  end
end