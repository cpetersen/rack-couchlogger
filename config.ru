require 'rubygems'
require 'couch_logger'
require 'hello_world'

use Rack::CouchLogger
run Rack::HelloWorld