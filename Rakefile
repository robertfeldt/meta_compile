require 'fileutils'

# A system command that prints commands to stdout before running them
def pexec(str)
	puts str
	STDOUT.flush
	system str
	puts ""
end

desc "Bootstrap our version of Long Nguyen's C version of Meta-II"
task :bootstrap_c do
	Dir.chdir "bootstrap"
	puts "1. Build bootstrap compiler"
	pexec "gcc -o bootstrapped_c bootstrap.c"
	puts "2. Use the bootstrapped meta compiler to compile the meta_for_c.txt description of itself"
	pexec "./bootstrapped_c meta_for_c.txt meta_compiler_from_boostrapped_c.c"
	puts "3. Build the compiler we created from the meta description"
	pexec "gcc -o meta_c meta_compiler_from_boostrapped_c.c"
	puts "4. Now use the generated compiler to generate itself"
	pexec "./meta_c meta_for_c.txt meta_compiler.c"
	puts "5. Now ensure the compilers are exactly the same"
	pexec "diff meta_compiler_from_boostrapped_c.c meta_compiler.c"
end

# Non-empty Lines of Code calc
def loc(filename)
	File.readlines(filename).map {|l| l.strip.length==0?nil:l}.compact.length
end

desc "Bootstrap the Ruby Meta-II compiler"
task :bootstrap do
	Dir.chdir("bootstrap") do
		puts "1. Build bootstrap compiler"
		pexec "gcc -o bootstrapped_c bootstrap.c"
		puts "2. Use the c meta compiler to compile the meta_for_ruby.txt description"
		pexec "./bootstrapped_c meta_for_ruby.txt compile_syntax_c_to_ruby.c"
		puts "3. Build the stepping stone ruby compiler we created from the meta description"
		pexec "gcc -o meta_r compile_syntax_c_to_ruby.c"
		puts "4. Now use the generated stepping stone compiler to generate a ruby compiler for the ruby meta syntax"
		pexec "./meta_r meta_for_ruby.txt meta_ruby_compiler_from_c.rb"
		puts "5. Run the generated ruby meta compiler to a ruby version"
		pexec "ruby -I. meta_ruby_compiler_from_c.rb meta_for_ruby.txt meta_ruby_compiler.rb"
		puts "6. The Ruby version differ in that it has single quotes instead of double quotes around emitted strings"
		#pexec "diff meta_ruby_compiler_from_c.rb meta_ruby_compiler.rb"
		puts "7. But we can generate again and ensure it is a meta compiler"
		pexec "ruby -I. meta_ruby_compiler.rb meta_for_ruby.txt meta_ruby_compiler2.rb"
		pexec "diff meta_ruby_compiler.rb meta_ruby_compiler2.rb"
		puts "8. One more round just to show off... :)"
		pexec "ruby -I. meta_ruby_compiler2.rb meta_for_ruby.txt meta_ruby_compiler3.rb"
		pexec "diff meta_ruby_compiler.rb meta_ruby_compiler3.rb"
		puts "Summary:\nCreated a #{loc('meta_ruby_compiler.rb')} line meta-II meta compiler from a #{loc('meta_for_ruby.txt')} line meta-II spec\n\n"
	end
end

def diff_files(f1, f2)
	File.read(f1) != File.read(f2)
end

def ensure_is_meta(generatedFile, specFile)
	pexec "ruby #{generatedFile} #{specFile} t.rb"
	pexec "ruby t.rb #{specFile} t2.rb"
	# Obviously we should now be able to go on and one... :)
	pexec "ruby t2.rb #{specFile} t3.rb"
	if diff_files("t.rb", "t2.rb") || diff_files("t2.rb", "t3.rb")
		puts "ERROR: #{generatedFile} is NOT a meta compiler"
		exit(-1)
	else
		puts "YES #{generatedFile} is meta!!!"
	end
end

desc "Ensure it is a meta compiler"
task :ensure_meta => [:bootstrap] do
  ensure_is_meta "bin/meta_compile", "bootstrap/meta_for_ruby.txt"
end

desc "Make binary from the bootstrapped ruby meta-II compiler"
task :make_bin => [:ensure_meta] do
	FileUtils.cp "bootstrap/meta_ruby_compiler.rb", "bin/meta_compile"
	FileUtils.chmod 0755, "bin/meta_compile"
	puts "Created binary in bin/meta_compile"
end

desc "Update line counts in README.template.md to make README.md"
task :update_readme => [:bootstrap] do
	rmeta2_compiler_loc = loc('bootstrap/meta_ruby_compiler.rb')
	rmeta2_spec_loc = loc('bootstrap/meta_for_ruby.txt')
	readme = File.read("README.template.md").gsub("%%RMetaII_SPEC_LOC%%", rmeta2_spec_loc.to_s)
	readme = readme.gsub("%%RMetaII_COMPILER_LOC%%", rmeta2_compiler_loc.to_s)
	File.open("README.md", "w") {|f| f.puts readme}
end

task :default => :make_bin

desc "Build the gem"
task :build_gem => [:make_bin] do
	Rake::Task["clean"].invoke
	FileUtils.rm_f Dir.glob("meta_compile-*.gem")
	pexec "gem build meta_compile.gemspec"
end

desc "Build and install gem"
task :install_gem => [:build_gem] do
	pexec "sudo gem install meta_compile*.gem"
end

desc "Deploy gem"
task :deploy => [:install_gem] do
	pexec "gem push meta_compile*.gem"
end

task :clean do
	Dir.chdir("bootstrap") do
	  FileUtils.rm_f  %w{bootstrapped_c meta_compiler_from_boostrapped_c.c meta_compiler.c meta_ruby_compiler2.rb meta_ruby_compiler3.rb meta_ruby_compiler_from_c.rb compile_syntax_c_to_ruby.c meta_c meta_r}
  end
  FileUtils.rm_f Dir.glob("t*.rb")
end

task :clobber => [:clean] do
	Dir.chdir("bootstrap") do
	  FileUtils.rm_f %w{meta_ruby_compiler.rb meta_compile*.gem}
	end
  FileUtils.rm_f Dir.glob("meta_compile-*.gem")
end