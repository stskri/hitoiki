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
    get 'users' => 'users#dummy' # 新規登録画面で登録失敗した際にURLが/usersとなり、リロードするとRouting Errorが表示されてしまうため、controller側で redirect_to new_user_registration_path を用意している
    resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy]
    resources :users, only: [:show, :edit, :update]
  end
end