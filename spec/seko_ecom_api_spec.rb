RSpec.describe SekoEcomAPI do
  it 'has a version number' do
    expect(SekoEcomAPI::VERSION).not_to be nil
  end

  it 'loads RedirectError in a fresh process' do
    lib = File.expand_path('../lib', __dir__)
    loaded = system(RbConfig.ruby, '-I', lib, '-e', 'require "seko_ecom_api"; SekoEcomAPI::RedirectError',
                    err: File::NULL)
    expect(loaded).to be true
  end
end
