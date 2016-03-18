# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "LexicalAnalyserGenR"
  spec.version       = '1.0'
  spec.authors       = ["Oleg Kanatov"]
  spec.email         = ["okanatov@gmail.com"]
  spec.summary       = %q{Generator of lexical analysers}
  spec.description   = %q{Generator of lexical analysers.}
  spec.homepage      = "http://domainforproject.com/"
  spec.license       = "MIT"

  spec.files         = ['lib/NAME.rb']
  spec.executables   = ['bin/NAME']
  spec.test_files    = ['tests/test_NAME.rb']
  spec.require_paths = ["lib"]
end
