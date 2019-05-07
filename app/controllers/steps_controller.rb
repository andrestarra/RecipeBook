# frozen_string_literal: true

# Steps controller
class StepsController < ApplicationController
  before_action :authenticate_user!
  def edit
    @recipe = Recipe.find(params[:recipe_id])
    @step = Step.find(params[:id])  
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.new(step_params)
    
    if @step.save
      flash[:notice] = 'Step successfully created'
    else
      flash[:alert] = 'Step could not be created'
    end
    redirect_to recipe_path(@recipe)
  end

  def update
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.find(params[:id])
  
    if @step.update(step_params)
      flash[:notice] = 'Step successfully updated'
    else
      flash[:alert] = 'Step could not be updated'
    end
    redirect_to recipe_path(@recipe)
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.find(params[:id])
    @step.destroy
    redirect_to recipe_path(@recipe)
    flash[:error] = 'Step successfully destroyed'
  end

  private

  def step_params
    params.require(:step).permit(
      :operation, :expected_minutes, :comment,
      uses_attributes: %i[id quantity measure step_id ingredient_id _destroy],
      utilities_attributes: %i[id step_id utensil_id _destroy]
    )
  end
end
