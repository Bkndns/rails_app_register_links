Rails.application.routes.draw do

  root to: "application#index", :defaults => { :format => 'json' }
  
  get "/404" => "application#render_404", :defaults => { :format => 'json' }
  get "/500" => "application#render_500", :defaults => { :format => 'json' }
  
  get 'visited_domains', to: 'application#visited_domains', :defaults => { :format => 'json' }
  post 'visited_links', to: 'application#visited_links', :defaults => { :format => 'json' }

  get "*path", :to => "application#render_404", :defaults => { :format => 'json' }
  post "*path", :to => "application#render_404", :defaults => { :format => 'json' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
