require 'rubygems'
require 'sinatra'

module Rack
  class HelloWorld < Sinatra::Base
    get '/' do
      "Hello World"
    end
  end
end