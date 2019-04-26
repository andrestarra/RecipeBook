# frozen_string_literal: true

# Plates Controller
class PlatesController < ApplicationController
  before_action :authenticate_user!
  def index
    @plates = Plate.my_dishes
  end

  def show
    @plate = Plate.my_dishes.find(params[:id])
  end

  def new
    @plate = Plate.new
  end

  def edit
    @plate = Plate.my_dishes.find(params[:id])
  end

  def create
    @plate = Plate.new(plate_params)
    @plate.user_id = current_user.id

    if @plate.save
      redirect_to @plate
      flash[:notice] = 'Plate successfully created'
    else
      render 'new'
      flash[:alert] = 'Plate could not be created'
    end
  end

  def update
    @plate = Plate.find(params[:id])
    @plate.user_id = current_user.id

    if @plate.update(plate_params)
      redirect_to @plate
      flash[:notice] = 'Plate successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Plate could not be updated'
    end
  end

  def destroy
    @plate = Plate.find(params[:id])
    @plate.destroy

    redirect_to plates_path
    flash[:error] = 'Plate successfully destroyed'
  end

  private

  def plate_params
    params.require(:plate).permit(:name, :main_ingredient, :type_plate, :price,
                                  :comment, :menu_id)
  end
end
