# -*- coding: utf-8; mode: ruby  -*-

$:.push File.expand_path("../lib", __FILE__)

require "reservation/version"


Gem::Specification.new do |gem|
  gem.name          = "reservation"
  gem.version       = Reservation::VERSION
  gem.authors       = ["Conan Dalton"]
  gem.email         = ["conan@conandalton.net"]
  gem.description   = %q{A very basic reservation system using ActiveRecord}
  gem.summary       = %q{A very basic reservation system using ActiveRecord}
  gem.homepage      = "http://github.com/conanite/reservation"

  gem.add_dependency             "rails", "~> 3.0"
  gem.add_dependency             'activerecord', '~> 3.0'
  gem.add_dependency             'icalendar'

  gem.add_development_dependency 'rspec', '~> 2.9'
  gem.add_development_dependency "sqlite3"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
