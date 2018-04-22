Gem::Specification.new do |s|
  s.name        = 'shift_stats'
  s.version     = '0.1.0'
  s.date        = Date.today.to_s
  s.summary     = 'Shift stats API'
  s.description = 'Interfaces with Digital Shift APIs (HockeyShift, BasketballShift, etc.)'
  s.authors     = ['Chris Pickett']
  s.email       = 'chris@parnic.com'
  s.files       = ['lib/shift_stats.rb', 'lib/shift_stats/configuration.rb']
  s.homepage    = 'https://github.com/parnic/shift_stats'
  s.license       = 'MIT'
  s.add_runtime_dependency 'httpclient', '~> 2'
  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'rspec', '~> 3'
end
