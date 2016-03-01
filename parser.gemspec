Gem::Specification.new do |s|
  s.name = "parser"
  s.summary = "Parsers roman numbers and returns their representation in arabic numbers."
  s.requirements = [ '' ]
  s.version = "0.0.1"
  s.author = "Oleg Kanatov"
  s.email = "okanatov@gmail.com"
  s.homepage = ""
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.8'
  s.files = Dir['lib/parser.rb']
  s.executables = [ 'bin/parser' ]
  s.test_files = Dir["test/test*.rb"]
  s.has_rdoc = false
end
