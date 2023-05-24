RSpec.describe SekoEcomAPI::Object do
  subject { described_class }

  describe 'initialize' do
    context 'with hash' do
      it do
        object = subject.new({ foo: 'bar' })
        expect(object).to be_a(OpenStruct)
        expect(object.foo).to eq('bar')
      end
    end

    context 'with nested hash' do
      it do
        object = subject.new({foo: { bar: 'foo'}})
        expect(object).to be_a(OpenStruct)
        expect(object.foo.bar).to eq('foo')
      end
    end

    context 'with array' do
      it do
        object = subject.new(foo: [{foo_1: { bar_1: 1}}, {foo_2: { bar_2: 2}}])
        expect(object).to be_a(OpenStruct)
        expect(object.foo.first.foo_1.bar_1).to eq 1
        expect(object.foo.last.foo_2.bar_2).to eq 2
      end
    end
  end
end
