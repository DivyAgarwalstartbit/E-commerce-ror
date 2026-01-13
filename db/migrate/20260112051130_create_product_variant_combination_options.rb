class CreateProductVariantCombinationOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :product_variant_combination_options do |t|
      t.references :product_variant_combination,
                   null: false,
                   foreign_key: true,
                   index: { name: "idx_pvco_combination" }

      t.references :product_variant_option,
                   null: false,
                   foreign_key: true,
                   index: { name: "idx_pvco_option" }
    end

    add_index :product_variant_combination_options,
              [:product_variant_combination_id, :product_variant_option_id],
              unique: true,
              name: "idx_pvco_unique"
  end
end
