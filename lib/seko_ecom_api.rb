# frozen_string_literal: true

require_relative "seko_ecom_api/version"

module SekoEcomAPI
  autoload :Error, 'seko_ecom_api/error'
  autoload :Object, 'seko_ecom_api/object'

  # Objects
  autoload :Rate, 'seko_ecom_api/objects/rate'
  autoload :Shipment, 'seko_ecom_api/objects/shipment'
end
