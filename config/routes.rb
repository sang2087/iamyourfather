Iamyourfather::Application.routes.draw do
  get "map/index"

  get "map/seize"

  get "map/independance"

  get "map/betray"

	get "map/session_destory"


  match "map/data.gexf" => "map#data"
  match "map/data.json" => "map#groups"
  match "map/user.json" => "map#get_user"

  root :to => 'map#index'

	match ':id' => 'map#index'
end
