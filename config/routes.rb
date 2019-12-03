Myrottenpotatoes::Application.routes.draw do
  resources :movies
  post '/movies/search_tmdb'
  root :to => redirect('/movies')
end
