# endeco

https://github.com/morimori/endeco

## DESCRIPTION

Manages environment dependent configurations.

Like "envdir", contained in djb's daemontools.
see http://cr.yp.to/daemontools/envdir.html

## FEATURES

* File based configuration
* Dynamic configuration on running apps (if cache disabled)
* Rails integration

## SYNOPSIS

    $ cat sample.rb
    require 'rubygems'
    require 'endeco'
    Endeco::Config.path = 'env'
    Endeco::Config.env  = 'development'
    print Endeco.hoge
    print Endeco.fuga

    $ mkdir -p env/development
    $ echo 'foo' > env/development/hoge
    $ echo 'bar' > env/development/fuga
    $ ruby sample.rb
    foo
    bar

### Rails integration
#### setup configuration files

    $ cd $RAILS_ROOT
    $ mkdir -p env/{development,production}
    $ echo 'foo' > env/development/hoge
    $ echo 'bar' > env/production/hoge`

#### Gemfile

    ...
    gem 'endeco', :require => 'endeco/rails'
    ...

#### result

    $ bundle exec rails runner -e development 'Endeco.hoge'
    foo
    $ bundle exec rails runner -e production 'Endeco.hoge'
    bar

## REQUIREMENTS:

ruby 1.8.7 or higher / ruby 1.9.2 or higher

## INSTALL:

    $ gem install endeco

## LICENSE:

(The MIT License)

Copyright (c) 2011 Takatoshi -morimori- MORIYAMA

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
