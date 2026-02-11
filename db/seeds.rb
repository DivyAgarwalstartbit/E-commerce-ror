puts "Cleaning database..."

ProductVariantCombinationitem.destroy_all
ProductVariantCombination.destroy_all
ProductVariant.destroy_all
Product.destroy_all
Category.destroy_all
Collection.destroy_all

puts "Creating collections..."

womens = Collection.create!(
  name: "Womens",
  description: "Explore the latest trends in women's fashion."
)

mens = Collection.create!(
  name: "Mens",
  description: "Discover stylish and modern outfits for men."
)

kids = Collection.create!(
  name: "Kids",
  description: "Fun, colorful and comfortable clothing for kids."
)

puts "Creating categories..."

womens_dresses = Category.create!(name: "Dresses", collection: womens)
womens_tshirts = Category.create!(name: "T-shirt", collection: womens)

mens_shirts = Category.create!(name: "Shirt", collection: mens)
mens_tshirts = Category.create!(name: "T-shirt", collection: mens)

kids_wear = Category.create!(name: "Kids Wear", collection: kids)

puts "Creating products..."

products = []

products << Product.create!(
  name: "Floral Summer Dress",
  brand: "Zara",
  short_description: "Light and breezy summer dress.",
  description: "Beautiful floral dress perfect for summer.",
  specification: "Cotton fabric",
  featured: true,
  category: womens_dresses
)

products << Product.create!(
  name: "Classic White Shirt",
  brand: "H&M",
  short_description: "Slim fit formal shirt.",
  description: "Perfect for office and formal occasions.",
  specification: "100% Cotton",
  featured: true,
  category: mens_shirts
)

products << Product.create!(
  name: "Kids Cartoon T-shirt",
  brand: "MiniStyle",
  short_description: "Cute cartoon printed tee.",
  description: "Soft fabric with fun cartoon prints.",
  specification: "Polyester blend",
  featured: false,
  category: kids_wear
)

puts "Connecting products to collections..."

products.each do |product|
  product.collections << product.category.collection
end

puts "Creating variants and combinations..."

products.each do |product|
  case product.category.name
  when "Shirt", "T-shirt"
    sizes  = %w[S M L XL]
    colors = %w[Red Blue Black White]
  when "Dresses"
    sizes  = %w[XS S M L]
    colors = %w[Pink Yellow Blue]
  else
    sizes  = ["One-Size"]
    colors = ["Default"]
  end

  size_variants = sizes.map do |size|
    product.product_variants.create!(
      variant_type: "Size",
      value: size
    )
  end

  color_variants = colors.map do |color|
    product.product_variants.create!(
      variant_type: "Color",
      value: color
    )
  end

  size_variants.product(color_variants).each do |size_var, color_var|
    pvc = product.product_variant_combinations.create!(
      price: rand(20..100),
      compared_price: rand(101..150),
      stock_qunatity: rand(5..20),
      sku: "#{product.id}-#{size_var.value}-#{color_var.value}"
    )

    ProductVariantCombinationitem.create!(
      product_variant: size_var,
      product_variant_combination: pvc
    )

    ProductVariantCombinationitem.create!(
      product_variant: color_var,
      product_variant_combination: pvc
    )
  end
end

puts "Dummy data created successfully!"
