module SekoEcomAPI
  class Error < StandardError
  end

  class ParseError < StandardError
    attr_reader :response
    def initialize(message, response)
      super(message)
      @response = response
    end
  end
end
