meta_compile
============

A meta compilation framework for Ruby à la Meta-II by Val Schorre. 

Uses a C version of Meta-II developed by Long Nguyen's ([meta](https://github.com/impeachgod/meta)) to bootstrap a Ruby version from a [fully self-contained 28 (non-empty) line specification file](https://raw.github.com/robertfeldt/meta_compile/master/bootstrap/meta_for_ruby.txt).

Install
-------

Clone the git repo and then run:

        rake bootstrap

and it will bootstrap and print info about each step. This requires gcc, rake and a recent ruby.
