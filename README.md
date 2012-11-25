meta_compile
============

A meta compilation framework for Ruby à la [Meta-II by Val Schorre](http://ibm-1401.info/Meta-II-schorre.pdf).

This uses a [C version of Meta-II](https://github.com/impeachgod/meta) developed by Long Nguyen to bootstrap a Ruby version from a [fully self-contained, 27 (non-empty) line specification file](https://raw.github.com/robertfeldt/meta_compile/master/bootstrap/meta_for_ruby.txt). The [generated Ruby Meta-II compiler file](https://github.com/robertfeldt/meta_compile/blob/master/bin/meta_compile) is 234 lines of Ruby code.

Install
-------

Clone the git repo and then run:

        rake bootstrap

and it will bootstrap and print info about each step. This requires gcc, rake and a recent ruby. 

If you only want the finished result you can just install as a gem:

        gem install meta_compile

since it is available on [rubygems.org](https://rubygems.org/gems/meta_compile).

Manually verifying that it is a meta compiler
---------------------------------------------

In your local copy of the git repo, use the pre-generated binary to compile the specification file to a ruby file:

        bin/meta_compile bootstrap/meta_for_ruby.txt t.rb

This generates a t.rb which is itself a compiler for meta syntax specs. So lets use it to generate itself:

        ruby t.rb bootstrap/meta_for_ruby.txt t2.rb

And ensure they are really the same:

        diff t.rb t2.rb

To be really sure we can try the generated t2.rb as a meta-compiler:

        ruby t2.rb bootstrap/meta_for_ruby.txt t3.rb

and this should convince us:

        diff t2.rb t3.rb

Limitations
-----------
+ Very bad/little error handling
