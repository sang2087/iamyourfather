Iamyourfather::Application.routes.draw do
	
	get "map/index"
	post "map/seize"
	post "map/independance"
	post "map/betray"

	root :to => 'map#index'

	match 'auth/:provider/callback', to: 'sessions#create'
	match 'auth/failure', to: redirect('/')
	match 'signout', to: "sessions#destroy", as: 'signout'

	match ':id' => 'map#index'

	match "data/data.gexf" => "send_data#data"
  match "data/user.json" => "send_data#get_user"
  match "data/friends.json" => "send_data#friends_list"

end
