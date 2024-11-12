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
    resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy]
    resources :users, only: [:show, :edit, :update]
  end
end