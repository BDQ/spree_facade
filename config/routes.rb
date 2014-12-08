Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :layouts
  end
end
