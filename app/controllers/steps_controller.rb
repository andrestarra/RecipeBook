# frozen_string_literal: true

# Steps controller
class StepsController < ApplicationController
  before_action :authenticate_user!
  def edit
    @recipe = Recipe.my_recipes.find(params[:recipe_id])
    @step = Step.find(params[:id])
  end

  def create
    @recipe = Recipe.my_recipes.find(params[:recipe_id])
    begin
      @step = @recipe.steps.new(step_params)
      redirect_to recipe_path(@recipe)
      if @step.save
        flash[:notice] = 'Step successfully created'
      else
        flash[:alert] = 'Step could not be created'
      end
    rescue ActiveRecord::NestedAttributes::TooManyRecords
      redirect_to recipe_path(@recipe)
      flash[:error] = 'Too many records'
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = 'Duplicate key value violates unique constraint'
    end
  end

  def update
    @recipe = Recipe.my_recipes.find(params[:recipe_id])
    @step = @recipe.steps.find(params[:id])
    redirect_to recipe_path(@recipe)
    if @step.update(step_params)
      flash[:notice] = 'Step successfully updated'
    else
      flash[:alert] = 'Step could not be updated'
    end
  end

  def destroy
    @recipe = Recipe.my_recipes.find(params[:recipe_id])
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
