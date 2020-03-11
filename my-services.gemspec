Gem::Specification.new do |s|
  s.name        = 'my-services'
  s.version     = '0.0.11'
  s.date        = '2019-12-11'
  s.summary     = 'MyServices ruby api'
  s.description = "To interact with MyService's API"
  s.authors     = ['Sahu Minaketana']
  s.email       = 'minosahu31@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/my-services'
  s.license     = 'MIT'
  s.files = [
    "lib/my-services.rb",
    "lib/my-services/errors/my_services_error.rb",
    "lib/my-services/errors/authentication_error.rb",
    "lib/my-services/errors/invalid_request_error.rb",
    "lib/my-services/errors/connection_error.rb",
    "lib/my-services/actions/post.rb",
    "lib/my-services/my_services_object.rb",
    "lib/my-services/worker.rb"
  ]
  s.add_dependency('activesupport', '~> 4.2')
  s.add_dependency('rest-client', '~> 2.1')

  s.add_development_dependency('rake', '~> 11.2')
  s.add_development_dependency('rspec', '~> 3.8')
  s.add_development_dependency('rspec-its', '~> 1.3')
  s.add_development_dependency('rubocop', '~> 0.77')
  s.add_development_dependency('webmock', '~> 3.7')

  # s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end

