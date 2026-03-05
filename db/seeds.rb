puts "Cleaning database..."

Message.destroy_all
Conversation.destroy_all
Payment.destroy_all
LineItem.destroy_all
Order.destroy_all
Cart.destroy_all
BillingDetail.destroy_all
WishlistItem.destroy_all
Wishlist.destroy_all

ProductVariantCombinationitem.destroy_all
ProductVariantCombination.destroy_all
ProductVariant.destroy_all
Product.destroy_all
Category.destroy_all
Collection.destroy_all
User.destroy_all

puts "Database cleaned ✅"

# =====================================================
# COLLECTIONS
# =====================================================

featured      = Collection.create!(name: "Featured")
best_sellers  = Collection.create!(name: "Best sellers")
hot_trends    = Collection.create!(name: "Hot Trends")
women_fashion = Collection.create!(name: "Women fashion")
men_fashion   = Collection.create!(name: "Men fashion")
kid_fashion  = Collection.create!(name: "Kid fashion")
cosmetics     = Collection.create!(name: "Cosmetics")
accessoriess   = Collection.create!(name: "Accessories")
all_products  = Collection.create!(name: "All products")

puts "Collections created ✅"

# =====================================================
# CATEGORY DEFINITIONS (PRIMARY COLLECTION + EXTRA)
# =====================================================

category_structure = {
  # MEN
  "Mens Shirt"      => { primary: men_fashion,   extra: [best_sellers] },
  "Mens T-shirt"    => { primary: men_fashion,   extra: [best_sellers] },
  "Mens Trousers"   => { primary: men_fashion,   extra: [hot_trends] },
  "Mens Cream"      => { primary: men_fashion,   extra: [cosmetics, hot_trends] },
  "Mens Wallets"    => { primary: men_fashion,   extra: [accessoriess, featured] },

  # WOMEN
  "Womens Shirt"    => { primary: women_fashion, extra: [best_sellers] },
  "Womens T-shirt"  => { primary: women_fashion, extra: [best_sellers] },
  "Womens Trousers" => { primary: women_fashion, extra: [featured, hot_trends] },
  "Womens Cream"    => { primary: women_fashion, extra: [cosmetics, featured] },
  "Womens Wallets"  => { primary: women_fashion, extra: [accessoriess] },

  # KIDS
  "Kids Shirt"      => { primary: kid_fashion,  extra: [best_sellers] },
  "Kids T-shirt"    => { primary: kid_fashion,  extra: [featured] },
  "Kids Trousers"   => { primary: kid_fashion,  extra: [featured] },
  "Kids Toys"       => { primary: kid_fashion,  extra: [accessoriess, hot_trends] },
  "Kids Cream"      => { primary: kid_fashion,  extra: [cosmetics, hot_trends] }
}

puts "Creating categories..."

categories = {}

category_structure.each do |name, data|
  categories[name] = Category.create!(
    name: name,
    collection: data[:primary]
  )
end

puts "Categories created ✅"

# =====================================================
# VARIANT CONFIG
# =====================================================

sizes  = %w[XXS XS S M L XL]
colors = %w[Black White Red Grey Blue Beige Green Yellow]

clothing_types = ["Shirt", "T-shirt", "Trousers"]

# =====================================================
# CREATE 2 PRODUCTS PER CATEGORY
# =====================================================

puts "Creating products..."

categories.each do |category_name, category|

  2.times do |i|

    product = Product.create!(
      name: "#{category_name} #{i + 1}",
      slug: "#{category_name.parameterize}-#{i + 1}",
      brand: ["Zara", "H&M", "Nike", "Levis", "Adidas"].sample,
      short_description: "Premium quality #{category_name.downcase}",
      description: "High quality #{category_name.downcase} designed for comfort and style.",
      specification: "Premium fabric / material",
      featured: [true, false].sample,
      category: category
    )

    # Attach collections
    product.collections << category.collection
    category_structure[category_name][:extra].each do |col|
      product.collections << col
    end
    product.collections << all_products

    # =========================================
    # CLOTHING PRODUCTS (Size + Color Matrix)
    # =========================================

   if clothing_types.any? { |type| category_name.include?(type) }

  # Pick 2 sizes and 2 colors
  selected_sizes  = sizes.sample(2)
  selected_colors = colors.sample(2)

  size_variants = selected_sizes.map do |size|
    product.product_variants.create!(
      variant_type: "Size",
      value: size
    )
  end

  color_variants = selected_colors.map do |color|
    product.product_variants.create!(
      variant_type: "Color",
      value: color
    )
  end

  # Create combinations (2 x 2 = 4)
  size_variants.product(color_variants).each do |size_var, color_var|

    pvc = product.product_variant_combinations.create!(
      price: rand(25..150),
      compared_price: rand(151..250),
      stock_qunatity: rand(10..50),
      sku: "#{product.slug}-#{size_var.value}-#{color_var.value}".downcase
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

else
  # Non clothing (single variant)

  variant = product.product_variants.create!(
    variant_type: "Default",
    value: "Standard"
  )

  pvc = product.product_variant_combinations.create!(
    price: rand(10..120),
    compared_price: rand(121..200),
    stock_qunatity: rand(10..60),
    sku: "#{product.slug}-standard"
  )

  ProductVariantCombinationitem.create!(
    product_variant: variant,
    product_variant_combination: pvc
  )

end
  end
end

puts "Products & variants created ✅"

# =====================================================
# SINGLE ADMIN
# =====================================================

admin = User.create!(
  email: "admin@example.com",
  password: "123456",
  password_confirmation: "123456"
)

admin.add_role(:admin)

puts "Admin created ✅"
puts "🎉 FULL E-COMMERCE STORE SEEDED SUCCESSFULLY!"