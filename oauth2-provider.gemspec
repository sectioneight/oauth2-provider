# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "oauth2/provider/version"

Gem::Specification.new do |s|
  s.name        = "oauth2-provider"
  s.version     = OAuth2::Provider::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tom Ward"]
  s.email       = ["tom@popdog.net"]
  s.homepage    = "http://tomafro.net"
  s.summary     = %q{OAuth2 Provider, extracted from api.hashblue.com}
  s.description = %q{OAuth2 Provider, extracted from api.hashblue.com}

  s.files         = %w[
    lib/oauth2-provider.rb
    lib/oauth2/provider.rb
    lib/oauth2/provider/models.rb
    lib/oauth2/provider/models/access_token.rb
    lib/oauth2/provider/models/active_record.rb
    lib/oauth2/provider/models/active_record/access_token.rb
    lib/oauth2/provider/models/active_record/authorization.rb
    lib/oauth2/provider/models/active_record/authorization_code.rb
    lib/oauth2/provider/models/active_record/client.rb
    lib/oauth2/provider/models/authorization.rb
    lib/oauth2/provider/models/authorization_code.rb
    lib/oauth2/provider/models/client.rb
    lib/oauth2/provider/models/mongoid.rb
    lib/oauth2/provider/models/mongoid/access_token.rb
    lib/oauth2/provider/models/mongoid/authorization.rb
    lib/oauth2/provider/models/mongoid/authorization_code.rb
    lib/oauth2/provider/models/mongoid/client.rb
    lib/oauth2/provider/rack.rb
    lib/oauth2/provider/rack/access_token_handler.rb
    lib/oauth2/provider/rack/authorization_code_request.rb
    lib/oauth2/provider/rack/authorization_codes_support.rb
    lib/oauth2/provider/rack/middleware.rb
    lib/oauth2/provider/rack/resource_request.rb
    lib/oauth2/provider/rack/responses.rb
    lib/oauth2/provider/rails.rb
    lib/oauth2/provider/rails/controller_authentication.rb
    lib/oauth2/provider/random.rb
    lib/oauth2/provider/version.rb
    spec/models/access_token_spec.rb
    spec/models/authorization_code_spec.rb
    spec/models/authorization_spec.rb
    spec/models/client_spec.rb
    spec/models/random_token_spec.rb
    spec/requests/access_tokens_controller_spec.rb
    spec/requests/authentication_spec.rb
    spec/requests/authorization_code_request_spec.rb
    spec/requests/middleware_spec.rb
    spec/schema.rb
    spec/set_backend_env_to_mongoid.rb
    spec/spec_helper.rb
    spec/support/activerecord_backend.rb
    spec/support/factories.rb
    spec/support/macros.rb
    spec/support/mongoid_backend.rb
    spec/support/rack.rb
  ]

  s.test_files    = %w[
    spec/models/access_token_spec.rb
    spec/models/authorization_code_spec.rb
    spec/models/authorization_spec.rb
    spec/models/client_spec.rb
    spec/models/random_token_spec.rb
    spec/requests/access_tokens_controller_spec.rb
    spec/requests/authentication_spec.rb
    spec/requests/authorization_code_request_spec.rb
    spec/requests/middleware_spec.rb
    spec/schema.rb
    spec/set_backend_env_to_mongoid.rb
    spec/spec_helper.rb
    spec/support/activerecord_backend.rb
    spec/support/factories.rb
    spec/support/macros.rb
    spec/support/mongoid_backend.rb
    spec/support/rack.rb
  ]

  s.require_paths = ["lib"]

  # Main dependencies
  s.add_dependency 'activesupport', '~>3.0'
  s.add_dependency 'addressable', '~>2.2'
  s.add_dependency 'httpauth', '~> 0.1'

  s.add_development_dependency 'rack-test', '~>0.5.7'
  s.add_development_dependency 'activerecord', '~>3.0'
  s.add_development_dependency 'rspec', '~>2.9.0'
  s.add_development_dependency 'mocha', '~>0.9.12'
  s.add_development_dependency 'rake', '~>0.9.2'
  s.add_development_dependency 'sqlite3', '~>1.3.5'
  s.add_development_dependency 'timecop', '~>0.3.4'
  s.add_development_dependency 'yajl-ruby', '~>0.7.5'
  s.add_development_dependency 'mongoid', '2.0.0.rc.6'
  s.add_development_dependency 'bson', '1.2.0'
  s.add_development_dependency 'bson_ext', '1.2.0'
end
