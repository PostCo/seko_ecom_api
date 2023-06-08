require_relative 'seko_ecom_api/version'

module SekoEcomAPI
  autoload :Error, 'seko_ecom_api/error'
  autoload :ParseError, 'seko_ecom_api/error'
  autoload :Object, 'seko_ecom_api/object'
  autoload :Client, 'seko_ecom_api/client'

  # Objects
  autoload :Rate, 'seko_ecom_api/objects/rate'
  autoload :Shipment, 'seko_ecom_api/objects/shipment'

  # Clients
  autoload :OmniReturnsClient, 'seko_ecom_api/clients/omni_returns_client'
end
