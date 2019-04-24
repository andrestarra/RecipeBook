# frozen_string_literal: true

# Ingredients Controller
class IngredientsController < ApplicationController
  before_action :authenticate_user!
  def index
    @ingredients = Ingredient.all
  end

  def show
    @ingredient = Ingredient.find(params[:id])
  end

  def new
    @ingredient = Ingredient.new
  end

  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to @ingredient
      flash[:notice] = 'Ingredient successfully created'
    else
      render 'new'
      flash[:alert] = 'Ingredient could not be created'
    end
  end

  def update
    @ingredient = Ingredient.find(params[:id])

    if @ingredient.update(ingredient_params)
      redirect_to @ingredient
      flash[:notice] = 'Ingredient successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Ingredient could not be updated'
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    redirect_to ingredients_path
    flash[:error] = 'Ingredient successfully destroyed'
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :calories)
  end
end
