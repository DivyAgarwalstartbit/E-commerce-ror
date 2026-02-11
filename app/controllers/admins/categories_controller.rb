class Admins::CategoriesController < Admins::ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.includes(:collection)
  end

  def show
    @products = @category.products
  end

  def new
    @category = Category.new
    @collections = Collection.all
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_category_path(@category), notice: "Category created successfully"
    else
      @collections = Collection.all
      render :new
    end
  end

  def edit
    @collections = Collection.all
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: "Category updated successfully"
    else
      @collections = Collection.all
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "Category deleted successfully"
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :collection_id)
  end
end
