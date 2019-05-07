# frozen_string_literal: true

# Menus controller
class MenusController < ApplicationController
  before_action :authenticate_user!
  def index
    @menus = Menu.my_menus
  end

  def show
    @menu = Menu.my_menus.find(params[:id])
  end

  def new
    @menu = Menu.new
  end

  def edit
    @menu = Menu.my_menus.find(params[:id])
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.user_id = current_user.id

    if @menu.save
      redirect_to @menu
      flash[:notice] = 'Menu successfully created'
    else
      render 'new'
      flash[:alert] = 'Menu could not be created'
    end
  end

  def update
    @menu = Menu.my_menus.find(params[:id])

    if @menu.update(menu_params)
      redirect_to @menu
      flash[:notice] = 'Menu successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Menu could not be updated'
    end
  end

  def destroy
    @menu = Menu.my_menus.find(params[:id])
    @menu.destroy

    redirect_to menus_path
    flash[:error] = 'Menu successfully destroyed'
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :type_menu)
  end
end
