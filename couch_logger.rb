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
      log = Log.new(env)
      log.response_time = (Time.now - start)
      # TODO, save asynchronously with l.save(true)
      log.save
      result
    end
  end
end
