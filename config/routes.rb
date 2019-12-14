Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # 動確用
  root :to => 'youtubes#index'
  # linebot用
  post '/callback' => 'linebots#callback'
end
