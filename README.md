meta_compile
============

A meta compilation framework for Ruby à la [Meta-II by Val Schorre](http://ibm-1401.info/Meta-II-schorre.pdf).

This uses a [C version of Meta-II](https://github.com/impeachgod/meta) developed by Long Nguyen to bootstrap a Ruby version from a [fully self-contained, 26 (non-empty) line specification file](https://raw.github.com/robertfeldt/meta_compile/master/syntaxes/meta_to_ruby_minimal.meta). The [generated Ruby Meta-II compiler file](https://github.com/robertfeldt/meta_compile/blob/master/bin/meta_compile) is 231 lines of Ruby code.

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

        bin/meta_compile syntaxes/meta_to_ruby_minimal.meta > t.rb

This generates a t.rb which is itself a compiler for meta syntax specs. So lets use it to generate itself:

        ruby t.rb syntaxes/meta_to_ruby_minimal.meta > t2.rb

And ensure they are really the same:

        diff t.rb t2.rb

To be really sure we can try the generated t2.rb as a meta-compiler:

        ruby t2.rb syntaxes/meta_to_ruby_minimal.meta > t3.rb

and this should convince us:

        diff t2.rb t3.rb

Limitations
-----------
+ Very bad/little error handling

Ok, now what?
-------------

Once the first meta compiler is up and running we can evolve the language. For example I made a change so [Ruby regexps can be used](https://github.com/robertfeldt/meta_compile/blob/master/syntaxes/meta_to_ruby_minimal_with_regexps.meta) instead of only string literals. Note that we need to use a [stepping stone syntax file](https://github.com/robertfeldt/meta_compile/blob/master/syntaxes/stepping_stone_meta_to_ruby_minimal_with_regexps.meta) before we can create a new meta compiler that accepts the new syntax.

Let's use this to compile programs which can only contain assignments of numbers to variables:

        .syntax assignments
        assignments = as *as;
        as = /\w+/ <'address ' $> ':=' ex1 <'store'> ';';
        ex1 = /\d+/ <'literal ' $>;
        .end

First we create a compiler for this syntax:

        rake bootstrap_re # Use my extended meta syntax to create a new compiler that accepts regexps
        ruby bin/metacomp_re syntaxes/assignments.meta > tas.rb # Use new compiler to compile the assingment syntax

We now have a compiler for assignments and if we apply it [to the file](https://raw.github.com/robertfeldt/meta_compile/master/inputs/assignments.input1):

        a := 13;
        b := 45;

by running the command:

        ruby tas.rb inputs/assignments.input1

it prints:

        address a
        literal 13
        store
        address d
        literal 4
        store
