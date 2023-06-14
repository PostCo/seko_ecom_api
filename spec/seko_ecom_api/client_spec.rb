RSpec.describe SekoEcomAPI::Client do
  subject { client }
  let(:client) { Class.new { extend SekoEcomAPI::Client } }
  describe '#parse_params' do
    let(:params) { { "foo_bar": 'foo', 'bar_foo': 'bar' } }
    it 'transform snake case keys to camel case keys' do
      expect(subject.parse_params(params).keys).to eq ["FooBar", "BarFoo"]
    end
  end
end
