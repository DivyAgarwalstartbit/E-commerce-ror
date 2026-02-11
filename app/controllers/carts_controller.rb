class CartsController < ApplicationController
     def index
    @cart = current_cart
    @line_items = @cart.line_items
  end
end 
