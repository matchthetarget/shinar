require "net/http"
require "json"

class TimezoneService
  def self.detect_timezone(ip_address)
    url = URI.parse("http://ip-api.com/json/#{ip_address}?fields=status,message,timezone")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)

      if data["status"] == "success" && data["timezone"].present?
        data["timezone"]
      else
        "UTC" # Default timezone
      end
    else
      "UTC" # Default timezone
    end
  rescue StandardError => e
    Rails.logger.error("Timezone detection error: #{e.message}")
    "UTC" # Default timezone
  end
end
