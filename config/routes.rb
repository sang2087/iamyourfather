Iamyourfather::Application.routes.draw do
  get "map/index"

  get "map/seize"

  get "map/independence"

  get "map/betray"

  match "map/data.gexf" => "map#data"
  match "map/data.json" => "map#groups"

  root :to => 'map#index'

	match ':id' => 'map#index'
end
