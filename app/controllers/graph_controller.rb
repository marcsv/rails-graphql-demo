class GraphController < ApplicationController
  def create
    query_string = params[:query]
    query_variables = params[:variables]

    response_data = GraphSchema.execute(query_string, variables: query_variables)

    render json: response_data
  end
end
