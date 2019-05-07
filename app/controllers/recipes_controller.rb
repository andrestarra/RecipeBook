# frozen_string_literal: true

# Recipes Controller
class RecipesController < ApplicationController
  before_action :authenticate_user!
  def index
    @recipes = Recipe.my_recipes
  end

  def show
    @recipe = Recipe.my_recipes.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def edit
    @recipe = Recipe.my_recipes.find(params[:id])
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    if @recipe.save
      redirect_to @recipe
      flash[:notice] = 'Recipe successfully created'
    else
      render 'new'
      flash[:alert] = 'Recipe could not be created'
    end
  end

  def update
    @recipe = Recipe.my_recipes.find(params[:id])

    if @recipe.update(recipe_params)
      redirect_to @recipe
      flash[:notice] = 'Recipe successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Recipe could not be updated'
    end
  end

  def destroy
    @recipe = Recipe.my_recipes.find(params[:id])
    @recipe.destroy

    redirect_to recipes_path
    flash[:error] = 'Recipe successfully destroyed'
  end

  private

  def recipe_params
    params.require(:recipe).permit(:source, :location, :total_minutes, :plate_id)
  end
end
