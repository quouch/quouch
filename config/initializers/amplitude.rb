# Configure your Amplitude API key
AmplitudeAPI.config.api_key = Rails.application.credentials.dig(:amplitude, :api_key)
AmplitudeAPI.config.options = {min_id_length: 1}
