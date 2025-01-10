Rails.application.routes.draw do
  # API routes
  # namespace เป็นการกำหนด path ของ API ให้เป็น /api/v1/...
  namespace :api do
    namespace :v1 do
      namespace :user do
        post "sign_in" => "sessions#sign_in"
        delete "sign_out" => "sessions#sign_out"
        get "me" => "sessions#me"

        # Blogs
        resources :blogs
      end
    end
  end
end
