require "open-uri"
require "json"
require "net/http"
require "uri"

PEXELS_API_KEY = "4rx60i0YevfesNwafVGzNVafOTuMv1tozB7oIOOZ6UKaRMP5tVFHxQlS" # <- Replace with your API key

# =====================================================
# HELPER FUNCTIONS
# =====================================================

def fetch_pexels_image(query)
  url = URI("https://api.pexels.com/v1/search?query=#{URI.encode_www_form_component(query)}&per_page=5")
  req = Net::HTTP::Get.new(url)
  req["Authorization"] = PEXELS_API_KEY

  res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }
  data = JSON.parse(res.body)
  data["photos"]&.sample&.dig("src", "original")
rescue
  nil
end

def attach_featured_image(product, image_url)
  image_url ||= "https://via.placeholder.com/500"
  product.featured_image.attach(io: URI.open(image_url), filename: "#{product.slug}-featured.jpg")
end

def attach_variant_image(variant_combination, image_url)
  image_url ||= "https://via.placeholder.com/500"
  variant_combination.image.attach(io: URI.open(image_url), filename: "#{variant_combination.sku}.jpg")
end
# =====================================================
# CLEAN DATABASE
# =====================================================
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
kid_fashion   = Collection.create!(name: "Kid fashion")
cosmetics     = Collection.create!(name: "Cosmetics")
accessoriess  = Collection.create!(name: "Accessories")
all_products  = Collection.create!(name: "All products")

puts "Collections created ✅"

# =====================================================
# CATEGORY STRUCTURE
# =====================================================
category_structure = {
  "Mens Shirt"      => { primary: men_fashion,   extra: [best_sellers] },
  "Mens T-shirt"    => { primary: men_fashion,   extra: [best_sellers] },
  "Mens Trousers"   => { primary: men_fashion,   extra: [hot_trends] },
  "Mens Cream"      => { primary: men_fashion,   extra: [cosmetics, hot_trends] },
  "Mens Wallets"    => { primary: men_fashion,   extra: [accessoriess, featured] },

  "Womens Shirt"    => { primary: women_fashion, extra: [best_sellers] },
  "Womens T-shirt"  => { primary: women_fashion, extra: [best_sellers] },
  "Womens Trousers" => { primary: women_fashion, extra: [featured, hot_trends] },
  "Womens Cream"    => { primary: women_fashion, extra: [cosmetics, featured] },
  "Womens Wallets"  => { primary: women_fashion, extra: [accessoriess] },

  "Kids Shirt"      => { primary: kid_fashion,  extra: [best_sellers] },
  "Kids T-shirt"    => { primary: kid_fashion,  extra: [featured] },
  "Kids Trousers"   => { primary: kid_fashion,  extra: [featured] },
  "Kids Toys"       => { primary: kid_fashion,  extra: [accessoriess, hot_trends] },
  "Kids Cream"      => { primary: kid_fashion,  extra: [cosmetics, hot_trends] }
}

categories = {}
category_structure.each do |name, data|
  categories[name] = Category.create!(name: name, collection: data[:primary])
end
puts "Categories created ✅"

# =====================================================
# VARIANTS CONFIG
# =====================================================
sizes  = %w[XXS XS S M L XL]
colors = %w[Black White Red Grey Blue Beige Green Yellow]
clothing_types = ["Shirt", "T-shirt", "Trousers"]

# =====================================================
# CREATE PRODUCTS & VARIANTS
# =====================================================
puts "Creating products..."

categories.each do |category_name, category|
  2.times do |i|
    product_name = "#{category_name} #{i + 1}"
    product = Product.create!(
      name: product_name,
      slug: product_name.parameterize,
      brand: ["Zara", "H&M", "Nike", "Levis", "Adidas"].sample,
      short_description: "Premium quality #{category_name.downcase}",
      description: "High quality #{category_name.downcase} designed for comfort and style.",
      specification: "Premium material",
      featured: [true, false].sample,
      category: category
    )

    # Attach featured image
    featured_image_url = fetch_pexels_image(product_name)
    attach_featured_image(product, featured_image_url)

    # Collections
    product.collections << category.collection
    category_structure[category_name][:extra].each { |col| product.collections << col }
    product.collections << all_products

    # ===============================================
    # CLOTHING VARIANTS
    # ===============================================
    if clothing_types.any? { |type| category_name.include?(type) }
      selected_sizes  = sizes.sample(2)
      selected_colors = colors.sample(2)

      size_variants = selected_sizes.map { |s| product.product_variants.create!(variant_type: "Size", value: s) }
      color_variants = selected_colors.map { |c| product.product_variants.create!(variant_type: "Color", value: c) }

      size_variants.product(color_variants).each do |size_var, color_var|
        pvc = product.product_variant_combinations.create!(
          price: rand(25..150),
          compared_price: rand(151..250),
          stock_qunatity: rand(10..50),
          sku: "#{product.slug}-#{size_var.value}-#{color_var.value}".downcase
        )

        ProductVariantCombinationitem.create!(product_variant: size_var, product_variant_combination: pvc)
        ProductVariantCombinationitem.create!(product_variant: color_var, product_variant_combination: pvc)

        # Attach variant image
        variant_image_url = fetch_pexels_image("#{product_name} #{color_var.value}")
        attach_variant_image(pvc, variant_image_url)
      end
    else
      # Non-clothing product
      variant = product.product_variants.create!(variant_type: "Default", value: "Standard")
      pvc = product.product_variant_combinations.create!(
        price: rand(10..120),
        compared_price: rand(121..200),
        stock_qunatity: rand(10..60),
        sku: "#{product.slug}-standard"
      )
      ProductVariantCombinationitem.create!(product_variant: variant, product_variant_combination: pvc)

      variant_image_url = fetch_pexels_image(product_name)
      attach_variant_image(pvc, variant_image_url)
    end
  end
end

puts "Products & variants with images created ✅"

# =====================================================
# ADMIN USER
# =====================================================
admin = User.create!(
  email: "admin@example.com",
  password: "123456",
  password_confirmation: "123456"
)
admin.add_role(:admin)

puts "Admin created ✅"
puts "🎉 FULL E-COMMERCE STORE SEEDED SUCCESSFULLY!"