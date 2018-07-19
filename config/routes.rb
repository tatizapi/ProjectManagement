Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

  root 'home#index'

  resources :admin, only: [:index]

  scope '/admin' do
    resources :clients
    resources :projects
    resources :employees
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
