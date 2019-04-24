# frozen_string_literal: true

# Steps controller
class StepsController < ApplicationController
  before_action :authenticate_user!
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.create(step_params)
    flash[:notice] = 'Step successfully created'
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
      :id, :operation, :expected_minutes, :comment,
      uses_attributes: %i[id quantity measure step_id ingredient_id _destroy],
      utilities_attributes: %i[id step_id utensil_id]
    )
  end
end
