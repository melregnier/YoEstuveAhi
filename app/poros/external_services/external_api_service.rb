module ExternalServices
	class ExternalApiService
		BASE_URL = { 1: 'react.url/caquita', 2: 'link.de.los.otros.com.asp.net' }


		def initialize(server_id)
			@server_id = server_id
			@base_url = BASE_URL[server_id]
		end

		# get location data
		def location_data(location_id)
			response = HTTParty.get( @base_url + '/location/' +  location_id)
			raise Errors::ExternalApiException.new(response.body['message']) unless response.code == 200

			response.body
		end

		# post check_in
		def check_in(location_id)
			response = HTTParty.post( @base_url + 'checkin/' + location_id)
			raise Errors::ExternalApiException.new(response.body['message']) unless response.code == 200

			response.body
		end

		#post check_out
		def check_out(location_id)
			response = HTTParty.post( @base_url + 'checkout/' + location_id)
			raise Errors::ExternalApiException.new(response.body['message']) unless response.code == 200

			response.body
		end
		
		#TO DO
		#post contagion/new
		#def check_out(list_of)
		#	response = HTTParty.post( @base_url + 'contagion/new')
			
		#end

	end	
end