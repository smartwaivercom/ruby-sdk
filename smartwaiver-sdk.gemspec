# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'smartwaiver-sdk/version'

Gem::Specification.new do |s|
  s.name        = 'smartwaiver-sdk'
  s.version     = SmartwaiverSDK::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Smartwaiver']
  s.email       = ['cs@smartwaiver.com']
  s.homepage    = 'https://github.com/smartwaivercom/ruby-sdk'
  s.summary     = %q{Smartwaiver SDK for version 4 of the API}
  s.description = %q{The Smartwaiver SDK uses version 4 of the Smartwaiver API}
  s.license     = "Apache-2.0"

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/smartwaivercom/ruby-sdk/issues',
    'changelog_uri'     => "https://github.com/smartwaivercom/ruby-sdk/blob/v#{s.version}/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/smartwaiver-sdk/#{s.version}",
    'source_code_uri'   => "https://github.com/smartwaivercom/ruby-sdk/tree/v#{s.version}",
    'wiki_uri'          => 'https://github.com/smartwaivercom/ruby-sdk/wiki'
  }

  s.required_ruby_version = '>= 2.0'

  s.add_development_dependency 'rspec', '>= 3.1.0'
  s.add_development_dependency 'webmock', '>= 3.18.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
