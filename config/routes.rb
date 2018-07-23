Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

  root 'home#index'

  resources :admin, only: [:index]

  resources :clients
  resources :projects do
    resources :tasks
  end
  resources :employees
  # resources :tasks
  # get '/projects/:id/assign' => 'projects#assign', as: :assign_to_project
  # patch 'projects/:id/assign' => 'projects#make_assign', as: :make_assign_to_project

  post '/projects/:id' => 'projects#add_developers', as: :add_developers
  post '/projects/:id' => 'projects#add_testers', as: :add_testers

  #
  # get '/employees/project/:project_id/task' => 'tasks#new', as: :new_task
  # post '/employees/project/:project_id/task' => 'tasks#create'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
