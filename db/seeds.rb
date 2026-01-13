puts "Cleaning database..."

Wishlist.delete_all
LineItem.delete_all
ProductVariantCombinationOption.delete_all
ProductVariantCombination.delete_all
ProductVariantOption.delete_all
CollectionProduct.delete_all
Product.delete_all
Category.delete_all
Collection.delete_all

puts "Database cleaned ✅"

# ---------------------------------------------------
# Collections
# ---------------------------------------------------
puts "Creating collections..."

all_products = Collection.find_or_create_by!(
  name: "All Products"
) do |c|
  c.description = "All products collection"
end

mens = Collection.find_or_create_by!(
  name: "Mens"
) do |c|
  c.description = "Mens collection"
end

womens = Collection.find_or_create_by!(
  name: "Womens"
) do |c|
  c.description = "Womens collection"
end

kids = Collection.find_or_create_by!(
  name: "Kids"
) do |c|
  c.description = "Kids collection"
end

# ---------------------------------------------------
# Categories
# ---------------------------------------------------
puts "Creating categories..."

mens_cat = Category.find_or_create_by!(
  name: "Shirts",
  gender: "Mens"
) { |c| c.collection = mens }

womens_cat = Category.find_or_create_by!(
  name: "Dresses",
  gender: "Womens"
) { |c| c.collection = womens }

kids_cat = Category.find_or_create_by!(
  name: "T-Shirts",
  gender: "Kids"
) { |c| c.collection = kids }

categories = [mens_cat, womens_cat, kids_cat]
collections = [mens, womens, kids]

# ---------------------------------------------------
# Products + Variants
# ---------------------------------------------------
puts "Creating products..."

10.times do |i|
  category = categories.sample

  product = Product.create!(
    name: "Product #{i + 1}",
    short_description: "Short description of product #{i + 1}",
    description: "Full description of product #{i + 1}",
    brand: "Nike",
    specification: "Cotton fabric",
    price: rand(50..100),
    compare_price: rand(110..150),
    category: category
  )

  # Attach image
  image_path = Rails.root.join("app/assets/images/default-product.jpeg")
  if File.exist?(image_path)
    product.featured_image.attach(
      io: File.open(image_path),
      filename: "default-product.jpeg"
    )
  end

  # Assign product to a collection
  product.collections << category.collection
  
product.collections << all_products


  # ---------------------------------------------------
  # Variant options
  # ---------------------------------------------------
  sizes  = %w[S M L]
  colors = %w[Red Blue Black]

  size_options = sizes.map do |size|
    ProductVariantOption.create!(
      product: product,
      variant_type: "Size",
      value: size
    )
  end

  color_options = colors.map do |color|
    ProductVariantOption.create!(
      product: product,
      variant_type: "Color",
      value: color
    )
  end

  # ---------------------------------------------------
  # Variant combinations
  # ---------------------------------------------------
  size_options.each do |size|
    color_options.each do |color|
      combination = ProductVariantCombination.create!(
        product: product,
        sku: "SKU-#{product.id}-#{size.value}-#{color.value}",
        stock: rand(5..20),
        price: product.price
      )

      ProductVariantCombinationOption.create!(
        product_variant_combination: combination,
        product_variant_option: size
      )

      ProductVariantCombinationOption.create!(
        product_variant_combination: combination,
        product_variant_option: color
      )
    end
  end
end

puts "Seeding completed successfully ✅"
