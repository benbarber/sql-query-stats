$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'sql_query_stats/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'sql_query_stats'
  s.version     = SqlQueryStats::VERSION
  s.authors     = ['Ben Barber']
  s.email       = ['contact@benbarber.co.uk']
  s.homepage    = ''
  s.summary     = 'Get more information from ActiveRecord'
  s.description = 'SqlQueryStats'
  s.license     = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails', '~> 5.1.5'

  s.add_development_dependency 'sqlite3'
end
