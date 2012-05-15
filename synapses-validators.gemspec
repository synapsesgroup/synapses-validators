$gemspec = Gem::Specification.new do |s|
  s.name        = 'synapses-validators'
  s.version     = '0.1.0'
  s.summary     = "Implements additional validations required to Synapses Group"
  s.description = "Adds CPF, CNPJ and Email validation"
  s.authors     = ["Synapses Group"]
  s.email       = ["tiago@synapses.com.br"]

  s.files  = [
    "CHANGELOG", "LICENSE", "README.md", "Rakefile",
   "lib/**/*.rb", "Gemfile", "synapses-validators.gemspec"
  ].map{|p| Dir[p]}.flatten

  s.homepage    = 'https://github.com/synapsesgroup/synapses-validators'
end