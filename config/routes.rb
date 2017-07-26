Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  get '/search' => 'books#search'    
  get '/faq' => 'faq#index'
  
  resources :books, except: :new do 
    resources :reviews
  end
  
  root to: 'books#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
