class Admins::CollectionsController < Admins::ApplicationController
  before_action :set_collection, only: %i[show edit update destroy]

  def index
    @collections = Collection.includes(:products, :categories)
  end

  def show
    @categories = @collection.categories
    @products   = @collection.products
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)
    if @collection.save
      redirect_to admins_collections_path, notice: "Collection created successfully"
    else
      render :new
    end
  end

  def edit; 
  end

  def update
    if @collection.update(collection_params)
      redirect_to admins_collections_path, notice: "Collection updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @collection.destroy
    redirect_to admins_collections_path, notice: "Collection deleted successfully"
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:name, :description , :featured_image)
  end
end
