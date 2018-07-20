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
  get '/employees/project/:id' => 'employees#details_project', as: :details_project


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
