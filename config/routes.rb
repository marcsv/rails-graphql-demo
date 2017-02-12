Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graph"
    root to: redirect("/graphiql")
  end
  
  resources :graph
end
