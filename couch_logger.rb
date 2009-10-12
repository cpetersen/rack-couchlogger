require 'couchrest'

class Log < CouchRest::ExtendedDocument
  database = CouchRest.new
  database.default_database = "logger"
  use_database database.default_database

  property :response_time

  # Example view, gives the average response time by path
  view_by :path_info_times,
          :map => "function(doc) {
            if ((doc['couchrest-type'] == 'Log') && doc['PATH_INFO']) {
              emit(doc['PATH_INFO'], doc['response_time']);
            }
          }
          ",
          :reduce => "function(key, values, rereduce) {
            return sum(values)/values.length;
          }"
end

module Rack
  class CouchLogger
    def initialize(app, options = {})
      @app = app
    end
  
    def call(env)
      start = Time.now
      result = @app.call(env)
      l = Log.new(env)
      l.response_time = (Time.now - start)
      l.save
      result
    end
  end
end
