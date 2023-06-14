RSpec.describe SekoEcomAPI::OmniReturnsClient do
  subject { SekoEcomAPI::OmniReturnsClient.new(access_key: ENV['ACCESS_KEY'], test: true, conn_opts: conn_opts) }
  let(:conn_opts) { {} }

  describe '#connection' do
    it 'uses the correct adapter and handlers' do
      connection = subject.connection
      expect(connection.builder.adapter).to eq Faraday::Adapter::HTTP
      expect(connection.builder.handlers).to include(Faraday::Request::Json, Faraday::Encoding)
    end

    context 'conn_opts is empty' do
      it do
        connection = subject.connection
        expect(connection.options.timeout).to eq nil
        expect(connection.options.open_timeout).to eq nil
      end
    end

    context 'conn_opts is not empty' do
      let(:conn_opts) { { timeout: 20, open_timeout: 20 } }
      it do
        connection = subject.connection
        expect(connection.options.timeout).to eq 20
        expect(connection.options.open_timeout).to eq 20
      end
    end
  end

  describe '#create_shipment' do
    let(:create_shipment_url) { "#{SekoEcomAPI::OmniReturnsClient::TEST_BASE_URL}labels/printshipment" }
    let(:status) { 200 }

    before do
      stub_request(:post, create_shipment_url).to_return(status: status, body: seko_response)
    end

    context 'success' do
      let(:seko_response) { { "CarrierId": 123, 'CarrierName': 'foo', 'Errors': [] }.to_json }
      it do
        shipment = subject.create_shipment({})
        expect(shipment).to be_a SekoEcomAPI::Shipment
      end
    end

    context 'failure' do
      context 'when errors is not empty' do
        let(:seko_response) { { 'Errors': ['Something went wrong'] }.to_json }
        it do
          expect { subject.create_shipment({}) }.to raise_error(SekoEcomAPI::Error)
        end
      end

      context 'when response with error status code' do
        let(:status) { [400, 'Bad request'] }
        let(:seko_response) { '' }
        it do
          expect { subject.create_shipment({}) }.to raise_error(SekoEcomAPI::Error)
        end
      end

      context 'when response body is in html' do
        let(:seko_response) { '<div>Errors: Bad request</div>'.to_json }
        it do
          expect { subject.create_shipment({}) }.to raise_error(SekoEcomAPI::ParseError)
        end
      end
    end
  end
end
