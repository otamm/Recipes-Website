require 'pg'
require 'sinatra'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes1')

    yield(connection)

  ensure
    connection.close
  end
end

def recipe_names()
  db_connection { |name| name.exec('SELECT name,id FROM recipes ORDER BY name').to_a}
end

def get_ingredients()
  db_connection { |ingr| ingr.exec_params('SELECT ingredients.name FROM ingredients,recipes WHERE ingredients.recipe_id = $1 AND ingredients.recipe_id = recipes.id',[@id]).to_a}
end

def get_specific_recipe()
  db_connection { |ingr| ingr.exec_params('SELECT name,instructions,description FROM recipes WHERE id = $1',[@id]).to_a}
end
get '/recipes' do
  @recipes = recipe_names()
  erb :index
end

get '/recipes/:id' do
  @id = params[:id]
  @recipe_page = get_specific_recipe()
  @ingredients = get_ingredients()
  erb :recipe_page
end
