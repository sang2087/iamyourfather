Iamyourfather::Application.routes.draw do
	
	get "map/index"
	post "map/seize"
	post "map/independance"
	post "map/betray"
	get "sessions/destroy"

	root :to => 'map#index'

	match 'auth/facebook/callback', to: 'sessions#create'
	match 'auth/facebook_messenger/callback', to: 'sessions#create_messenger'
	match 'auth/failure', to: redirect('/')
	match 'signout', to: "sessions#signout", as: 'signout'


	match ':id' => 'map#index'

	match "data/data.gexf" => "send_data#data"
  match "data/user.json" => "send_data#get_user"
  match "data/friends.json" => "send_data#friends_list"
  match "data/send_invitation" => "send_data#send_invitation"

end
