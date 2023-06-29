RSpec.describe SekoEcomAPI::OmniParcelClient do
  subject { SekoEcomAPI::OmniParcelClient.new(access_key: ENV['ACCESS_KEY'], conn_opts: conn_opts) }
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

  describe '#retrieve_rates' do
    let(:retrieve_rates_url) { "#{SekoEcomAPI::OmniParcelClient::BASE_URL}ratesqueryv1/availablerates" }
    let(:status) { 200 }

    before do
      stub_request(:post, retrieve_rates_url).to_return(
        status: status,
        body: seko_response,
        headers: { "Content-Type": 'application/json' }
      )
    end

    context 'success' do
      let(:seko_response) do
        { "Available": [{ id: 123, status: 'abc' }],
          "Hidden": [{ id: 234, status: 'bcd' }],
          "Rejected": [{ id: 345, status: 'cde' }] }.to_json
      end
      it do
        rates = subject.retrieve_rates({})
        expect(rates.members).to eq %i[available rejected hidden]
        expect(rates.available.first).to be_a SekoEcomAPI::Rate
        expect(rates.hidden.first).to be_a SekoEcomAPI::Rate
        expect(rates.rejected.first).to be_a SekoEcomAPI::Rate
      end
    end

    context 'failure' do
      context 'when there are validation errors' do
        let(:seko_response) do
          { "Available": [], "Rejected": [],
            "ValidationErrors": { 'packages' => 'Packages: Atleast 1 package required' } }.to_json
        end

        it do
          expect { subject.retrieve_rates({}) }.to raise_error(SekoEcomAPI::Error)
        end
      end

      context 'when response with error status code' do
        let(:status) { [400, 'Bad request'] }
        let(:seko_response) { '' }
        it do
          expect { subject.retrieve_rates({}) }.to raise_error(SekoEcomAPI::Error)
        end
      end
    end
  end
end
