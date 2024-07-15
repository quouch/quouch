# Configure Cloudinary
require "cloudinary"

Cloudinary.config_from_url(Rails.application.credentials.dig(:cloudinary, :url))
