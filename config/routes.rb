Rails.application.routes.draw do
  get '/', to: 'api/v1/datasource#base', as: 'base'
  post '/search/', to: 'api/v1/datasource#search', as: 'search'
  post '/query/', to: 'api/v1/datasource#query', as: 'query'
  post '/annotations/', to: 'api/v1/datasource#annotations', as: 'annotations'
end
