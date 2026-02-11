Product.find_each do |product|
  puts "Processing product: #{product.name}"
 
  # --- STEP 1: Define variants dynamically ---
  case product.category&.name
  when "Shirt", "T-shirt", "Mens", "Womens"
    sizes  = %w[S M L XL]
    colors = %w[Red Blue Green Black White]
  when "Dresses", "Kids"
    sizes  = %w[XS S M L]
    colors = %w[Pink Yellow Blue]
  else
    sizes  = %w[One-Size]
    colors = %w[Default]
  end
 
  # Create size variants
  sizes.each do |size|
    product.product_variants.find_or_create_by!(
      variant_type: "Size",
      value: size
    )
  end
 
  # Create color variants
  colors.each do |color|
    product.product_variants.find_or_create_by!(
      variant_type: "Color",
      value: color
    )
  end
 
  # --- STEP 2: Generate all combinations ---
  groups = product.product_variants.group_by(&:variant_type).values
 
  # Skip if no variants
  next if groups.empty?
 
  # Optionally, remove old combinations if you want to regenerate
  # product.product_variant_combinations.destroy_all
 
  # Generate all combinations
  groups.shift.product(*groups).each do |variant_set|
    pvc = product.product_variant_combinations.create!(
      price: rand(20..100),         # random price for demo
      compared_price: rand(101..150), # optional
      stock_qunatity: rand(5..20)    # random stock for demo
    )
 
    # Attach the variants to the combination
    pvc.product_variants << variant_set
    puts "Created combination: #{pvc.sku} → #{variant_set.map(&:value).join(', ')}"
  end
 
  puts "Done with #{product.name}"
end