# frozen_string_literal: true

# Welcome Controller
class WelcomeController < ApplicationController
  def index
    @recipes = Recipe.order(:created_at).reverse_order.last(5)
  end
end
