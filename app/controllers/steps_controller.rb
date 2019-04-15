# frozen_string_literal: true

# Steps controller
class StepsController < ApplicationController
  def index
    @steps = Step.all
  end

  def show
    @step = Step.find(params[:id])
  end

  def new
    @step = Step.new
  end

  def edit
    @step = Step.find(params[:id])
  end

  def create
    @step = Step.new(step_params)

    if @step.save
      redirect_to @step
    else
      render 'new'
    end
  end

  def update
    @step = Step.find(params[:id])

    if @step.update(step_params)
      redirect_to @step
    else
      render 'edit'
    end
  end

  def destroy
    @step = Step.find(params[:id])
    @step.destroy

    redirect_to steps_path
  end

  private

  def step_params
    params.require(:step).permit(:operation, :expected_minutes, :comment)
  end
end
