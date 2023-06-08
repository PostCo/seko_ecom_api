require 'active_support/core_ext/hash'

module SekoEcomAPI
  module Client
    def post_request(url, params: {}, headers: {})
      connection.post(url, params, headers)
    end

    def handle_response(response)
      error_message = response.body

      case response.status
      when 400
        raise Error, "A bad request or a validation exception has occurred. #{error_message}"
      when 401
        raise Error, "Invalid authorization credentials. #{error_message}"
      when 403
        raise Error, "Connection doesn't have permission to access the resource. #{error_message}"
      when 404
        raise Error, "The resource you have specified cannot be found. #{error_message}"
      when 429
        raise Error, "The API rate limit for your application has been exceeded. #{error_message}"
      when 500
        raise Error,
              "An unhandled error with the . Contact the Seko Ecom API team if problems persist. #{error_message}"
      when 503
        raise Error,
              "API is currently unavailable – typically due to a scheduled outage – try again soon. #{error_message}"
      end

      response
    end

    def parse_params(params)
      # Convert { snake_case_key: value } to { SnakeCaseKey: value }
      params.deep_transform_keys { |key| key.to_s.camelcase }
    end
  end
end
