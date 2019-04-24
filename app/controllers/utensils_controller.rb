# frozen_string_literal: true

# Utensils controller
class UtensilsController < ApplicationController
  before_action :authenticate_user!
  def index
    @utensils = Utensil.all
  end

  def show
    @utensil = Utensil.find(params[:id])
  end

  def new
    @utensil = Utensil.new
  end

  def edit
    @utensil = Utensil.find(params[:id])
  end

  def create
    @utensil = Utensil.new(utensil_params)

    if @utensil.save
      redirect_to @utensil
      flash[:notice] = 'Utensil successfully created'
    else
      render 'new'
      flash[:alert] = 'Utensil could not be created'
    end
  end

  def update
    @utensil = Utensil.find(params[:id])

    if @utensil.update(utensil_params)
      redirect_to @utensil
      flash[:notice] = 'Utensil successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Utensil could not be updated'
    end
  end

  def destroy
    @utensil = Utensil.find(params[:id])
    @utensil.destroy

    redirect_to utensils_path
    flash[:error] = 'Utensil successfully destroyed'
  end

  private

  def utensil_params
    params.require(:utensil).permit(:name)
  end
end
