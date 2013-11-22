Iamyourfather::Application.routes.draw do
  get "map/index"

  get "map/seize"

  get "map/independence"

  get "map/betray"

	get "map/session_destory"

  match "map/data.gexf" => "map#data"

  root :to => 'map#index'

	match ':id' => 'map#index'
end
