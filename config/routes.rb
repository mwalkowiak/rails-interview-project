Rails.application.routes.draw do
  get 'home/stats' => 'home#stats'
  get 'welcome/index'

  # You can have the root of your site routed with "root"
  root 'home#stats'

  mount API::Base => '/api'
end
