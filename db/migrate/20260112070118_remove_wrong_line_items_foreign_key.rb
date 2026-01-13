class RemoveWrongLineItemsForeignKey < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :line_items, column: :product_variant_combination_id, to_table: :product_variant_options
  end
end
