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

  resources :tasks, only: [:show] do
    resources :comments
  end

  get 'projects/:id/developers' => 'projects#developers', as: :project_developers
  get 'projects/:id/testers' => 'projects#testers', as: :project_testers
  post '/projects/:id/developers' => 'projects#manage_developers'
  post '/projects/:id/testers' => 'projects#manage_testers'

  #not sure this is the right way to do it
  #voiam doar ca o actiune din controller sa se execute in momentul in care se apasa pe un buton
  put '/projects/:id/dashboard/change_status' => 'dashboard#change_status', as: :change_status

  #for downloading file in a task
  get '/projects/:id/dashboard/:attachment' => 'dashboard#download', :constraints => {:attachment => /.*/ }, as: :download_file

  #for subtasks
  get '/projects/:project_id/tasks/new/(:owner)' => 'tasks#new', as: :new_project_subtask

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
