def pexec(str)
	puts str
	STDOUT.flush
	system str
	puts ""
end

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

task :bootstrap_ruby do
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
	end
end

require 'fileutils'

task :make_bin => [:bootstrap_ruby] do
	FileUtils.cp "bootstrap/meta_ruby_compiler.rb", "bin/meta_compiler"
	FileUtils.chmod 0755, "bin/meta_compiler"
	puts "Created binary in bin/meta_compiler"
end

task :default => :make_bin

task :clean do
	Dir.chdir("bootstrap") do
	  pexec "rm -rf bootstrapped_c meta_compiler_from_boostrapped_c.c meta_compiler.c meta_ruby_compiler2.rb meta_ruby_compiler3.rb meta_ruby_compiler_from_c.rb compile_syntax_c_to_ruby.c meta_c meta_r"
  end
end

task :clobber => [:clean] do
	Dir.chdir("bootstrap") do
	  pexec "rm -rf meta_ruby_compiler.rb"
	end
end