Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  # TODO get?
  get 'logout', to: 'sessions#destroy'

  namespace :api do
    resources :user_exams, only: [:index] do
      member do
        put :sync_user_answers
      end
    end

    get 'user_exams/:exam_id', to: 'user_exams#show'

    resources :exams, only: [:show, :update]
  end

  get 'api' => proc { [404, {}, ['Invalid API endpoint']] }
  get 'api/*path' => proc { [404, {}, ['Invalid API endpoint']] }

  root 'home#index'
  get '*path', to: 'home#index'
end
