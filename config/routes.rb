Iamyourfather::Application.routes.draw do
  get "map/index"

  post "map/seize"

  post "map/independance"

  post "map/betray"

	get "map/session_destory"


  match "map/data.gexf" => "map#data"
  match "map/data.json" => "map#groups"
  match "map/user.json" => "map#get_user"

  root :to => 'map#index'

	match ':id' => 'map#index'
end
