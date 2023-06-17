require 'faraday'
require 'faraday/encoding'
require 'faraday/http'

module SekoEcomAPI
  class OmniParcelClient
    include Client

    BASE_URL = 'https://api.omniparcel.com/'
    TEST_BASE_URL = 'https://staging.omniparcel.com/'

    attr_reader :access_key, :adapter, :test, :conn_opts

    def initialize(access_key:, adapter: :http, test: false, conn_opts: {})
      @access_key = access_key
      @adapter = adapter
      @test = test
      @conn_opts = conn_opts
    end

    def retrieve_rates(params)
      response = handle_response post_request('ratesqueryv1/availablerates', params: params)

      available_rates = response['available']&.map { |rate| Rate.new(rate) }
      rejected_rates = response['rejected']&.map { |rate| Rate.new(rate) }
      hidden_rates = response['hidden']&.map { |rate| Rate.new(rate) }

      Struct.new(:available, :rejected, :hidden).new(available_rates, rejected_rates, hidden_rates)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = test ? TEST_BASE_URL : BASE_URL
        conn.options.merge!(conn_opts)
        conn.headers['Access_Key'] = access_key
        conn.request :json
        conn.response :json, content_type: 'application/json'
        conn.response :encoding
        conn.adapter adapter
      end
    end

    private

    def handle_response(response)
      super
      transformed_body = response.body.deep_transform_keys(&:underscore)

      validation_errors = transformed_body['validation_errors']
      raise Error, "Something went wrong. Validation errors message: #{validation_errors}" if validation_errors.present?

      transformed_body
    end
  end
end
