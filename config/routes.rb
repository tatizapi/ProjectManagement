Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :admin, only: [:index]
  resources :clients
  resources :projects do
    resources :tickets
    resources :dashboard, only: [:index]
    resources :chat, only: [:index, :create]
  end
  resources :employees

  resources :tickets, only: [:show] do
    resources :comments
  end

  get 'projects/:id/developers' => 'projects#developers', as: :project_developers
  get 'projects/:id/testers' => 'projects#testers', as: :project_testers
  post '/projects/:id/developers' => 'projects#manage_developers'
  post '/projects/:id/testers' => 'projects#manage_testers'

  #not sure this is the right way to do it
  #voiam doar ca o actiune din controller sa se execute in momentul in care se apasa pe un buton
  put '/projects/:project_id/dashboard/change_status/:ticket_id' => 'dashboard#change_status', as: :change_status

  #for downloading file in a ticket
  get '/projects/:id/dashboard/:attachment' => 'dashboard#download', :constraints => {:attachment => /.*/ }, as: :download_file

  #for subtasks
  get '/projects/:project_id/tickets/new/(:owner)' => 'tickets#new', as: :new_project_subticket

  #deleting attachments
  delete 'projects/:id/attachment/:attachment_id' => 'projects#delete_attachment', as: :project_delete_attachment
  delete 'tickets/:id/attachment/:attachment_id' => 'tickets#delete_attachment', as: :ticket_delete_attachment
  delete 'tickets/:ticket_id/comments/:id/attachment/:attachment_id' => 'comments#delete_attachment', as: :comment_delete_attachment

  #for realtime chat
  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
