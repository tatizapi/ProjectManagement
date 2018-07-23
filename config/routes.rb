Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

  root 'home#index'

  resources :admin, only: [:index]

  namespace :admin do
    resources :clients
    resources :projects
    resources :employees
    get '/projects/assign/:id' => 'projects#assign', as: :assign_to_project
    patch 'projects/assign/:id' => 'projects#make_assign', as: :make_assign_to_project
  end

  resources :clients

  resources :projects

  resources :employees
  get '/employees/project/:id' => 'employees#details_project',
                                    as: :details_project
  post'/employees/project/:id' => 'employees#add_new_project_employees',
                                    as: :add_new_project_employees

  #resources :tasks, only: [:show, :index, :update, :destroy]
  get '/employees/project/:project_id/task' => 'tasks#new', as: :new_task
  post '/employees/project/:project_id/task' => 'tasks#create'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
