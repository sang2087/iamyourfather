Iamyourfather::Application.routes.draw do
  get "map/index"

  get "map/seize"

  get "map/independence"

  get "map/betray"


  root :to => 'map#index'

	match ':id' => 'map#index'
end
