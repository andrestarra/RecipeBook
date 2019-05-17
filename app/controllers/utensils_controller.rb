# frozen_string_literal: true

# Utensils controller
class UtensilsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!
  

  def index
    @utensils = Utensil.my_utensils
  end

  def show
    @utensil = Utensil.my_utensils.find(params[:id])
  end

  def new
    @utensil = Utensil.new
  end

  def edit
    @utensil = Utensil.my_utensils.find(params[:id])
  end

  def create
    @utensil = Utensil.new(utensil_params)
    @utensil.user_id = current_user.id
    
    if @utensil.save
      respond_to do |format|
        format.json { render json: { utensil: @utensil } }
        format.html { redirect_to @utensil }
      end
      flash[:notice] = 'Utensil successfully created'
    else
      respond_to do |format|
        format.json { render json: { utensil_error: @utensil.errors.full_messages }, status: 422 }
        format.html { render 'new' }
      end
      flash[:alert] = 'Utensil could not be created'
    end
  end

  def update
    @utensil = Utensil.my_utensils.find(params[:id])

    if @utensil.update(utensil_params)
      redirect_to @utensil
      flash[:notice] = 'Utensil successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Utensil could not be updated'
    end
  end

  def destroy
    @utensil = Utensil.my_utensils.find(params[:id])
    @utensil.destroy

    redirect_to utensils_path
    flash[:error] = 'Utensil successfully destroyed'
  end

  private

  def utensil_params
    params.require(:utensil).permit(:name)
  end
end
