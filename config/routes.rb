Iamyourfather::Application.routes.draw do
	
  get "errors/400"
  get "errors/422"
  get "errors/500"
	get "map/index"
	post "map/seize"
	get "map/seize"
	post "map/independance"
	get "map/independance"
	post "map/betray"
	get "map/betray"
	get "sessions/destroy"

	root :to => 'map#index'
	get "/" => "map#index"

	match 'auth/facebook/callback' => 'sessions#create', via: [:get, :post]
	match 'auth/facebook_messenger/callback' => 'sessions#create_messenger', via: [:get, :post]
	match 'auth/failure' => redirect('/'), via: [:get, :post]
	match 'signout' => "sessions#signout", via: [:get, :post]


	get ':id' => 'map#index'

	match "data/data.gexf" => "send_data#data", via: [:get, :post]
	match "data/family_data.gexf" => "send_data#family_data", via: [:get, :post]
	match "data/data.json" => "send_data#source", via: [:get, :post]
	match "data/tree.svg" => "send_data#tree_svg", via: [:get, :post]
  match "data/user.json" => "send_data#get_user", via: [:get, :post]
  match "data/friends.json" => "send_data#friends_list", via: [:get, :post]
  match "data/send_invitation" => "send_data#send_invitation", via: [:get, :post]
	match "data/facebook_post" => "send_data#facebook_post", via: [:get, :post]
	match "data/save_banner" => "send_data#save_banner", via: [:get, :post]

end
