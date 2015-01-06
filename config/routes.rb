module FacadeConstraint
  def self.matches?(request)
    return false if request.path == '/'
    return false if request.path =~ %r{\A\/+(admin|account|cart|checkout|content|login|pg\/|orders|products|s\/|session|signup|shipments|states|t\/|tax_categories|user)+}
    true # TODO: check Facade page actually exists
  end
end

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :layouts
    resources :pages
  end

  constraints(FacadeConstraint) do
    get '/(*path)', to: 'render#show', as: 'static'
  end
end

