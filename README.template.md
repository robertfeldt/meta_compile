meta_compile
============

A meta compilation framework for Ruby à la [Meta-II by Val Schorre](http://ibm-1401.info/Meta-II-schorre.pdf).

Uses a C version of Meta-II developed by Long Nguyen's ([meta](https://github.com/impeachgod/meta)) to bootstrap a Ruby version from a [fully self-contained %%RMetaII_SPEC_LOC%% (non-empty) line specification file](https://raw.github.com/robertfeldt/meta_compile/master/bootstrap/meta_for_ruby.txt). The [generated Ruby Meta-II compiler file](https://github.com/robertfeldt/meta_compile/blob/master/bin/meta_compile) is %%RMetaII_COMPILER_LOC%% lines of non-empty Ruby code.

Install
-------

Clone the git repo and then run:

        rake bootstrap

and it will bootstrap and print info about each step. This requires gcc, rake and a recent ruby.
