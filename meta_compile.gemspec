Gem::Specification.new do |s|
  s.name        = 'meta_compile'
  s.version     = '0.0.13'
  s.date        = '2012-11-25'
  s.summary     = "meta compiler framework"
  s.description = "A meta compilation framework à la Meta-II by Val Schorre"
  s.authors     = ["Robert Feldt"]
  s.email       = 'robert.feldt@gmail.com'
  s.files       = ["Rakefile", "README.md", "meta_compile.gemspec"] + Dir.glob("bin/*") + Dir.glob("bootstrap/*") + Dir.glob("syntaxes/*")
  s.executables << 'meta_compile'
  s.homepage    =
    'http://rubygems.org/gems/meta_compile'
end