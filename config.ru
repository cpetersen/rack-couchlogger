require 'rubygems'
require 'couch_logger'

use Rack::CouchLogger
run lambda { [200, {"Content-Type" => "text/plain"}, ["Hello world!"]] }