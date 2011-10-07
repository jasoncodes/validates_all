spec = Gem::Specification.new do |s|
  s.name = 'validates_all'
  s.version = '0.0.1'
  s.summary = "`validates_all` validation method for ActiveRecord"
  s.description = %{Extends the built-in ActiveRecord Validations to add a "validates_all" method which is similar to "validates_each".}
  s.author = ''

  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.add_runtime_dependency 'activerecord', %w(~>3.0)
end
