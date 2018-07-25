Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

  root 'home#index'

  resources :admin, only: [:index]

  resources :clients
  resources :projects do
    resources :tasks
    resources :dashboard, only: [:index]
  end
  resources :employees
  # resources :tasks

  get '/projects/:id/add_employees' => 'projects#add_employees', as: :add_employees
  post '/projects/:id/add_developers' => 'projects#add_developers'
  post '/projects/:id/add_testers' => 'projects#add_testers'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
