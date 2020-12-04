module ExternalServices
	class ExternalApiService
		BASE_URL = {
			Rails.application.secrets.react_server_id => Rails.application.secrets.react_server_url,
			Rails.application.secrets.asp_server_id => Rails.application.secrets.asp_server_url
		}

		def initialize(server_id)
			@server_id = server_id
			@base_url = BASE_URL[server_id]
		end

		# get location data
		def location_data(location_id)
			response = HTTParty.get( @base_url + '/location/' +  location_id.to_s, headers: { 'Accept' => 'application/json' })
			body = JSON.parse(response.body)
			raise Errors::ExternalApiException.new(body['message']) unless response.code == 200

			body
		end

		# post check_in
		def check_in(location_id)
			response = HTTParty.post(
        @base_url + '/checkin/' + location_id.to_s,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
			)
			body = JSON.parse(response.body)
			raise Errors::ExternalApiException.new(body['message']) unless response.code == 200

			body
		end

		# post check_out
		def check_out(location_id)
			response = HTTParty.post(
        @base_url + '/checkout/' + location_id.to_s,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
			)
			body = JSON.parse(response.body)
			raise Errors::ExternalApiException.new(body['message']) unless response.code == 200

			body
		end

		# post contagion/new
    def notify_contagion(stays_body)
      response = HTTParty.post(
        @base_url + '/contagion/new',
        body: stays_body,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
			)
			body = JSON.parse(response.body)
      raise Errors::ExternalApiException.new(body['message']) unless response.code == 200

			body
		end
	end	
end