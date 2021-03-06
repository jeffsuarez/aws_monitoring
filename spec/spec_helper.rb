require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require 'i18n'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'webmock/rspec'

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_base_class_for_anonymous_controllers = true
  config.mock_with :rspec do |mocks|

    # This option should be set when all dependencies are being loaded
    # before a spec run, as is the case in a typical spec helper. It will
    # cause any verifying double instantiation for a class that does not
    # exist to raise, protecting against incorrectly spelt names.
    mocks.verify_doubled_constant_names = true

  end
end

WebMock.disable_net_connect!(allow_localhost: true)

if AwsMonitor::Application.config.assets.compile
  asset_dir = File.join(Rails.public_path, AwsMonitor::Application.config.assets.prefix)
  if File.exists? asset_dir
    puts 'Removing precompiled assets'
    FileUtils.rm_rf asset_dir, secure: true
  end
end

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'factory_girl_rails'
require 'database_cleaner'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
end

def factory
  described_class.name.demodulize.gsub('Controller', '').underscore.singularize.to_sym
end

def model_instance(options = {})
  factory_method = options.delete(:factory_method) || :build
  @model_instance ||= send(factory_method, factory, options)
end

def stub_request_body(content)
  body_stub = mock()
  body_stub.expects(:read).once.returns(content)
  ActionController::TestRequest.any_instance.stubs(body: body_stub)
end
