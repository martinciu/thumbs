require 'lumberjack'
require 'benchmark'

module Thumbs
  class Logger
    def initialize(app, logfile_path)
      @logger = Lumberjack::Logger.new(logfile_path, :time_format => "%Y-%m-%d %H:%M:%S", :roll => :daily, :flush_seconds => 5)
      @app = app
    end
    
    def call(env)
      env['thumbs.logger'] = []
      env['thumbs.logger'] << env['thumbs.url']
      env['thumbs.logger'] << env['thumbs.size']
      response = []
      realtime = Benchmark.realtime do
        response = @app.call(env)
      end
      status, headers, body = response
      env['thumbs.logger'] << sprintf('%.4f', realtime)
      @logger.info env['thumbs.logger'].join("\t")
      return [status, headers, body]
    end
  end
end