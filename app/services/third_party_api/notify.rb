require 'net/http'

module ThirdPartyApi  
  class Notify
    APIS = %w(http://localhost:5000/users http://localhost:5000/articles)

    def initialize(user)
      @user = user
    end

    def call
      APIS.each do |api_url|
        send_notification(api_url)
      end
    end

    private

    def third_party_apis
      Rails.configuration.third_party_apis
    end

    def send_notification(api_url)
      uri = URI(api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
      params = {user: @user}
      request.body = params.to_json
      response = http.request(request)
    end
  end
end
