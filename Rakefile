require 'fileutils'

# A system command that prints commands to stdout before running them
def pexec(str)
	puts str
	STDOUT.flush
	system str
	puts ""
end

desc "Bootstrap our version of Long Nguyen's C version of Meta-II"
task :boot_c do
	Dir.chdir "bootstrap" do
		puts "1. Build bootstrap compiler"
		pexec "gcc -o bootstrapped_c bootstrap.c"
		puts "2. Use the bootstrapped meta compiler to compile the meta_to_c.meta description of itself"
		pexec "./bootstrapped_c meta_to_c.meta meta_compiler_from_boostrapped_c.c"
		puts "3. Build the compiler we created from the meta description"
		pexec "gcc -o meta_c meta_compiler_from_boostrapped_c.c"
		puts "4. Now use the generated compiler to generate itself"
		pexec "./meta_c meta_to_c.meta meta_compiler.c"
		puts "5. Now ensure the compilers are exactly the same"
		pexec "diff meta_compiler_from_boostrapped_c.c meta_compiler.c"
	end
end

# Non-empty Lines of Code calc
def loc(filename)
	File.readlines(filename).map {|l| l.strip.length==0?nil:l}.compact.length
end

def bootstrap_from_c(syntaxFile)
	if syntaxFile =~ /^syntaxes/
		syntaxf = File.join("..", syntaxFile)
	else
		syntaxf = File.join("..", "syntaxes", syntaxFile)
	end
	Dir.chdir("bootstrap") do
		puts "1. Build bootstrap compiler"
		pexec "gcc -o bootstrapped_c bootstrap.c"
		puts "2. Use the c meta compiler to compile the meta_to_ruby_minimal.meta description"
		pexec "./bootstrapped_c #{syntaxf} compile_to_ruby.c"
		puts "3. Build the stepping stone ruby compiler we created from the meta description"
		pexec "gcc -o meta_r compile_to_ruby.c"
		puts "4. Now use the generated stepping stone compiler to generate a ruby compiler for the ruby meta syntax"
		pexec "./meta_r #{syntaxf} meta_ruby_compiler_from_c.rb"
		puts "5. Run the generated ruby meta compiler to a ruby version"
		pexec "ruby -I. meta_ruby_compiler_from_c.rb #{syntaxf} > meta_ruby_compiler.rb"
		puts "6. Ruby version differ since it has single instead of double quotes around strings"
		#pexec "diff meta_ruby_compiler_from_c.rb meta_ruby_compiler.rb"
		puts "7. But we can generate again and ensure it is a meta compiler"
		pexec "ruby -I. meta_ruby_compiler.rb #{syntaxf} > meta_ruby_compiler2.rb"
		pexec "diff meta_ruby_compiler.rb meta_ruby_compiler2.rb"
		puts "8. One more round just to show off... :)"
		pexec "ruby -I. meta_ruby_compiler2.rb #{syntaxf} > meta_ruby_compiler3.rb"
		pexec "diff meta_ruby_compiler.rb meta_ruby_compiler3.rb"
		puts "Summary:\nCreated a #{loc('meta_ruby_compiler.rb')} line meta-II meta compiler from a #{loc(syntaxf)} line meta-II spec\n\n"
  	ensure_is_meta "meta_ruby_compiler.rb", syntaxf, "../bin/meta_compile"
	end
end

# Bootstrap a syntax from the meta_compile compiler
def bootstrap_from_ruby(syntaxFile, targetName = "tgen.rb")
	syntaxf    = File.join("syntaxes", syntaxFile)
	# Assumes the ruby version has been bootstrapped from C and is installed as meta_compile
	pexec "ruby bin/meta_compile #{syntaxf} > #{targetName}"
	ensure_is_meta(targetName, syntaxf, targetName)
end

def diff_files(f1, f2)
	File.read(f1) != File.read(f2)
end

def ensure_is_meta(generatedFile, specFile, saveAsTarget = nil)
	pexec "ruby #{generatedFile} #{specFile} > t.rb"
	pexec "ruby t.rb #{specFile} > t2.rb"
	# Obviously we should now be able to go on and on... :)
	pexec "ruby t2.rb #{specFile} > t3.rb"
	begin
		if diff_files("t.rb", "t2.rb") || diff_files("t2.rb", "t3.rb")
			puts "ERROR: #{generatedFile} is NOT a meta compiler (generated from #{specFile})"
			exit(-1)
		else
			puts "YES #{generatedFile} is meta!!! (generated from #{specFile})"
			if saveAsTarget
				FileUtils.mv("t2.rb", saveAsTarget) 
				puts "Saved bootstrapped file as #{saveAsTarget}"
			end
			return true
		end
	ensure
		FileUtils.rm_f Dir.glob("t*.rb")
	end
end

def create_main_binary(sourceBinary)
	FileUtils.cp sourceBinary, "bin/meta_compile"
	FileUtils.chmod 0755, "bin/meta_compile"
	puts "Created main binary in bin/meta_compile from #{sourceBinary}"
end

def bootstrap_with_stepping_stone(syntaxFile, target)
	syntaxf    = File.join("syntaxes", syntaxFile)
	stepstonef = File.join("syntaxes", "stepping_stone_" + syntaxFile)
	pexec "ruby bin/meta_compile #{stepstonef} > tgen_stepstone.rb"
	pexec "ruby tgen_stepstone.rb #{syntaxf} > #{target}"
	ensure_is_meta(target, syntaxf, target)
end

desc "Bootstrap the Ruby meta compiler (uses the minimal syntax)"
task :boot do
	bootstrap_from_c "meta_to_ruby_minimal.meta"
end

desc "Bootstrap and set binary file permissions"
task :bootstrap => :boot do	
	FileUtils.chmod 0755, "bin/meta_compile"
end

desc "Bootstrap the minimal Ruby meta compiler (from the Ruby meta compiler)"
task :boot_minimal => :bootstrap do
	bootstrap_from_ruby "meta_to_ruby_minimal.meta", "bin/metac_minimal"
end

desc "Make main gem binary from the minimal ruby meta compiler"
task :make_bin_minimal => :boot_minimal do
	create_main_binary "bin/metac_minimal"
end

desc "Ensure minimal ruby meta it is a meta compiler"
task :ensure_meta_minimal => :make_bin_minimal do
  ensure_is_meta "bin/meta_compile", "syntaxes/meta_to_ruby_minimal.meta"
end

desc "Bootstrap the readable meta compiler (from the Ruby meta compiler)"
task :boot_readable => :make_bin_minimal do
	bootstrap_from_ruby "meta_to_ruby.meta", "bin/metac_readable"
end

desc "Make main gem binary from the readable ruby meta compiler"
task :make_bin_readable => :boot_readable do
	create_main_binary "bin/metac_readable"
end

desc "Ensure readable ruby meta it is a meta compiler"
task :ensure_meta_readable => :make_bin_readable do
  ensure_is_meta "bin/meta_compile", "syntaxes/meta_to_ruby.meta"
end

desc "Bootstrap the meta compiler that accepts regexps"
task :boot_regexp => :make_bin_minimal do
	bootstrap_with_stepping_stone("meta_to_ruby_minimal_with_regexps.meta", "bin/metac_regexp")
end

def run_example(compiler, example)
	puts "Compiling this input with #{compiler}:\n\n"
	puts File.read(example)
	puts "\ngives output:\n\n"
	pexec "ruby #{compiler} #{example}"
end

def metac_regexp_run_examples(syntaxFile, *inputs)
	pexec "ruby bin/metac_regexp #{syntaxFile} > tas.rb"
	inputs.each do |i|
	  run_example("tas.rb", "inputs/#{i}")
	end
end

desc "Compile all inputs for the assignments syntax"
task :ex_ass do
	metac_regexp_run_examples "syntaxes/assignments.meta", "assignments.input1"
end

desc "Update line counts in README.template.md to make README.md"
task :update => [:boot_minimal, :boot_regexp, :boot_readable] do
	readme = File.read("README.template.md")
	readme = readme.gsub("%%RMetaII_SPEC_LOC%%", loc('syntaxes/meta_to_ruby_minimal.meta').to_s)
	readme = readme.gsub("%%RMetaII_COMPILER_LOC%%", loc('bin/metac_minimal').to_s)
	readme = readme.gsub("%%RMetaII_READABLE_SPEC_LOC%%", loc('syntaxes/meta_to_ruby.meta').to_s)
	readme = readme.gsub("%%RMetaII_READABLE_COMPILER_LOC%%", loc('bin/metac_readable').to_s)
	File.open("README.md", "w") {|f| f.puts readme}
end

desc "Build the gem"
task :build_gem => [:update, :make_bin_readable] do
	Rake::Task["clean"].invoke
	FileUtils.rm_f Dir.glob("meta_compile-*.gem")
	pexec "gem build meta_compile.gemspec"
end

desc "Build and install gem"
task :install_gem => [:build_gem] do
	pexec "sudo gem install meta_compile*.gem"
end

desc "Deploy gem"
task :deploy => :build_gem do
	pexec "gem push meta_compile*.gem"
end

task :clean do
	Dir.chdir("bootstrap") do
	  FileUtils.rm_f  %w{bootstrapped_c meta_compiler_from_boostrapped_c.c meta_compiler.c meta_ruby_compiler2.rb meta_ruby_compiler3.rb meta_ruby_compiler_from_c.rb compile_to_ruby.c meta_c meta_r}
  end
  FileUtils.rm_f Dir.glob("t*.rb")
end

task :clobber => [:clean] do
	Dir.chdir("bootstrap") do
	  FileUtils.rm_f %w{meta_ruby_compiler.rb meta_compile*.gem}
	end
  FileUtils.rm_f Dir.glob("meta_compile-*.gem")
end

task :default => :make_bin_readable
