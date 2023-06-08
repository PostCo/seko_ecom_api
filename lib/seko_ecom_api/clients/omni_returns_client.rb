require 'faraday'
require 'faraday/encoding'
require 'faraday/http'
require 'active_support/core_ext/hash'

module SekoEcomAPI
  class OmniReturnsClient
    include Client

    BASE_URL = 'https://www.omniparcelreturns.com/index.php/api/'.freeze
    TEST_BASE_URL = 'https://test.omniparcelreturns.com/index.php/api/'.freeze

    attr_reader :access_key, :adapter, :test, :conn_opts

    def initialize(access_key:, adapter: :http, test: false, conn_opts: {})
      @access_key = access_key
      @adapter = adapter
      @test = test
      @conn_opts = conn_opts
    end

    def create_shipment(params)
      response = handle_response post_request('labels/printshipment', params: parse_params(params))
      Shipment.new(response)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = test ? TEST_BASE_URL : BASE_URL
        conn.ssl.verify = test ? false : true
        conn.options.merge!(conn_opts)
        conn.headers['Access_Key'] = access_key
        conn.request :json
        conn.response :encoding
        conn.adapter adapter
      end
    end

    private

    # since Seko seems to send a 200 OK response even if there're errors
    # we will need to also check for errors in the response body
    def handle_response(response)
      super
      parsed_response = parse_response(response)
      response_errors = parsed_response['errors']

      raise(Error, "Something went wrong. #{response_errors}") unless response_errors.empty?

      parsed_response
    end

    # need to be manual parsed here instead of in the middleware
    # since Seko response's Content-Type is always in 'text/html'
    # with the response body can be in JSON or in html
    def parse_response(response)
      parsed_response = JSON.parse(response.body)
      parsed_response.deep_transform_keys(&:underscore)
    rescue JSON::ParserError
      error_response = Struct.new(:body, :headers).new(response.body, response.headers)
      raise ParseError.new('Response body cannot be parsed.', error_response)
    end
  end
end
