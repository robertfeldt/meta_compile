Gem::Specification.new do |s|
  s.name        = 'meta_compile'
  s.version     = '0.1.3'
  s.summary     = "Meta compiler framework for Ruby"
  s.description = "A meta compilation framework à la Meta-II by Val Schorre, now for Ruby. Bootstrapped from a pure-C implementation of Meta-II but then self-hosting. A main attraction is that the core specification file is very short (~26 lines), and fully self-contained (both syntax and semantics in s single file) which makes it easy for Rubyists to get into the wonderful world of meta compilation. See github homepage for details and examples: https://github.com/robertfeldt/meta_compile"
  s.author      = "Robert Feldt"
  s.email       = 'robert.feldt@gmail.com'
  s.homepage    = 'https://github.com/robertfeldt/meta_compile'
  s.license     = 'MIT'
  s.files       = ["Rakefile", "README.md", "meta_compile.gemspec"] + Dir.glob("bin/*") + Dir.glob("bootstrap/*") + Dir.glob("syntaxes/*") + Dir.glob("inputs/*")
  s.executables << 'meta_compile'
  s.homepage    =
    'http://rubygems.org/gems/meta_compile'
end