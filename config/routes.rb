# frozen_string_literal: true

Rails.application.routes.draw do
  root 'projects#index'
  get 'projects/view' => 'projects#view'
  get 'trello' => 'trello#index'

  resources :projects do
    resources :due_dates do
      collection do
        post :generate
      end
    end
  end
end
