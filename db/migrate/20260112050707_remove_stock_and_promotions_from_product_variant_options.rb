class RemoveStockAndPromotionsFromProductVariantOptions < ActiveRecord::Migration[6.1]
  def change
    remove_column :product_variant_options, :in_stock, :integer
    remove_column :product_variant_options, :promotions, :string
  end
end
