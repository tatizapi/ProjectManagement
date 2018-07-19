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
    get '/projects/assign/:id' => 'projects#assign', as: :assign_to_project
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
