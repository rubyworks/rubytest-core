[![Rubytest](http://rubyworks.github.io/rubytest/assets/images/test_pattern.jpg)](http://rubyworks.github.io/rubytest)

# Rubytest

[![Home Page](http://img.shields.io/badge/home-page-blue.svg?style=flat)](http://rubyworks.github.io/rubytest)
[![User Guide](http://img.shields.io/badge/user-guide-blue.svg?style=flat)](http://wiki.github.com/rubyworks/rubytest)
[![Github Fork](http://img.shields.io/badge/github-fork-blue.svg?style=flat)](http://http://github.com/rubyworks/rubytest)
[![Build Status](http://img.shields.io/travis/rubyworks/rubytest.svg?style=flat)](http://travis-ci.org/rubyworks/rubytest)
[![Gem Version](http://img.shields.io/gem/v/rubytest.svg?style=flat)](http://rubygems.org/gem/rubytest)
[![Report Issue](http://img.shields.io/github/issues/rubyworks/rubytest.svg?style=flat)](http://github.com/rubyworks/rubytest/issues)
[![Gittip](http://img.shields.io/badge/gittip-$1/wk-green.svg?style=flat)](https://www.gittip.com/on/github/rubyworks/)


Rubytest is Ruby's Universal Test Harness. Think of it as a *testing meta-framework*.
It defines a straight-forward specification that any application can use to create
their own testing DSLs. Rubytest can be used for testing end-user applcations directly
or as the backend of a test framework. Since Rubytest controls the backend, multiple test
frameworks can be used in a single test suite, all of which can be run through one uniform
interface in a single process!


## Specification

The universal access point for testing is the `$TEST_SUITE` global array. A test
framework need only add compliant test objects to `$TEST_SUITE`. 
Rubytest will iterate through these objects. If a test object responds to
`#call`, it is run as a test procedure. If it responds to `#each` it is iterated
over as a test case with each entry handled in the same manner. All test 
objects must respond to `#to_s` so their description can be used in test
reports.

Rubytest handles assertions with [BRASS](http://rubyworks.github.com/brass)
compliance. Any raised exception that responds to `#assertion?` in the
affirmative is taken to be a failed assertion rather than simply an error. 
A test framework may raise a `NotImplementedError` to have a test recorded
as *todo* --a _pending_ exception to remind the developer of tests that still
need to be written. The `NotImplementedError` is a standard Ruby exception
and a subclass of `ScriptError`. The exception can also set a priority level
to indicate the urgency of the pending test. Priorities of -1 or lower
will generally not be brought to the attention of testers unless explicitly 
configured to do so.

That is the crux of Rubytest specification. Rubytest supports some
additional features that can makes its usage even more convenient.
See the [Wiki](http://github.com/rubyworks/test/wiki) for further details.


## Installation

Rubytest is available as a Gem package.

    $ gem install rubytest

Rubytest is compliant with Setup.rb layout standard, so it can
also be installed in an FHS compliant fashion if necessary.


## Running Tests

There are a few ways to run tests. 

### Via Command-line Tool

The easiest way to run tests is via the command line tool. You can read more about
it on its [manpage](http://rubyworks.github.com/rubytest/man/rubytest.1.html),
but we will quickly go over it here. 

The basic usage example is:

    $ rubytest -Ilib test/test_*.rb

The command line tool takes various options, most of which correspond directly
to the configuration options of the `Test.run/Test.configure` API. Use
`-h/--help` to see them all.

If you are using a build tool to run your tests, such as Rake or Ergo, shelling
out to `rubytest` is a good way to go as it keeps your test environment as 
pristine as possible, e.g.

    desc "run tests"
    task :test
      sh "rubytest"
    end

### Via Rake Task

There is also a Rake plug-in that can be installed called `rubytest-rake`.
Surf over to its [webpage](http://rubyworks.github.com/rubytest-rake) for details.
A basic example in its case, add to ones Rakefile:

    require 'rubytest/rake'

    Test::Rake::TestTask.new :test do |run|
      run.requires << 'lemon'
      run.test_files = 'test/test_*.rb'
    end

See the Wiki for more detailed information on the different ways to run tests.

### Via Runner Scripts

Out of the box Rubytest doesn't provide any special means for doing so,
you simply write you own runner script using the Rubytest API.
Here is the basic example:

    require 'rubytest'

    Test.run! do |r|
      r.loadpath 'lib'
      r.test_files 'test/test_*.rb'
    end

Put that in a `test/runner.rb` script and run it with `ruby` or
add `#!/usr/bin/env ruby` at the top and put it in `bin/test`
setting `chmod u+x bin/test`. Either way, you now have your test
runner.


## Requirements

Rubytest uses the [ANSI](http://rubyworks.github.com/ansi) gem for color output.

Because of the "foundational" nature of this library we will look at removing
this dependency for future versions, but for early development the 
requirements does the job and does it well.


## Development

Rubytest is still a bit of a "nuby" gem. Please feel OBLIGATED to help improve it ;-)

Rubytest is a [Rubyworks](http://rubyworks.github.com) project. If you can't
contribute code, you can still help out by contributing to our [development fund](https://www.gittip.com/on/github/rubyworks/).


## Reference Material

* [Standard Definition Of Unit Test](http://c2.com/cgi/wiki?StandardDefinitionOfUnitTest)
* [BRASS Assertions Standard](http:rubyworks.github.com/brass)


## Copyrights

Copyright (c) 2011 Rubyworks

Made available according to the terms of the <b>BSD-2-Clause</b> license.

See LICENSE.txt for details.

