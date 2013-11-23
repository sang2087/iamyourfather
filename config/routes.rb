Iamyourfather::Application.routes.draw do
	
	get "map/index"
	post "map/seize"
	post "map/independance"
	post "map/betray"
	get "map/session_destory"

	root :to => 'map#index'


	match 'auth/:provider/callback', to: 'sessions#create'
	match 'auth/failure', to: redirect('/')
	match 'signout', to: "sessions#destroy", as: 'signout'

	match ':id' => 'map#index'

	match "map/data.gexf" => "map#data"
  match "map/data.json" => "map#groups"
  match "map/user.json" => "map#get_user"

	match "app/locale" => 'application#get_i18n_locale'
end
