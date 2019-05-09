# frozen_string_literal: true

# Welcome Controller
class WelcomeController < ApplicationController
  before_action :only_unlogged, only: [:show]

  def index
    @recipes = Recipe.order(:created_at).reverse_order.last(5)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def only_unlogged
    if user_signed_in?
      flash[:error] = "You haven't access to this url"
      redirect_to root_path
    end
  end
end
