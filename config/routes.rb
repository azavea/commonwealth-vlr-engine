Rails.application.routes.draw do
  get 'map', :to => 'catalog#map', :as => 'map'
end

