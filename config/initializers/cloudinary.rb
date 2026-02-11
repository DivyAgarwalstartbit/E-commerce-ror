Cloudinary.config do |config|
  config.cloud_name = Rails.application.credentials.dig(:cloudinary, :cloud_name) || "dre0nlty7"
  config.api_key    = Rails.application.credentials.dig(:cloudinary, :api_key) || "287288737671578"
  config.api_secret = Rails.application.credentials.dig(:cloudinary, :api_secret) || "VtXziH7fxu_0EqLBVuY84aTsNtY"
  config.secure     = true
end
