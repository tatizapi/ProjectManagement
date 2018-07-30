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

  get 'projects/:id/developers' => 'projects#developers', as: :project_developers
  get 'projects/:id/testers' => 'projects#testers', as: :project_testers
  post '/projects/:id/developers' => 'projects#manage_developers'
  post '/projects/:id/testers' => 'projects#manage_testers'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
