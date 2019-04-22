# frozen_string_literal: true

# Steps controller
class StepsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.create(step_params)
    redirect_to recipe_path(@recipe)
  end

  # def update
  #   @step = Step.find(params[:id])

  #   if @step.update(step_params)
  #     redirect_to @step
  #   else
  #     render 'edit'
  #   end
  # end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @step = @recipe.steps.find(params[:id])
    @step.destroy
    redirect_to recipe_path(@recipe)
  end

  private

  def step_params
    params.require(:step).permit(
      :id, :operation, :expected_minutes, :comment,
      uses_attributes: %i[id quantity measure step_id ingredient_id _destroy]
    )
  end
end
