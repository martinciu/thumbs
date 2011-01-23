require 'logger'
require 'benchmark'

module Thumbs
  class Logger
    def initialize(app, logfile_path)
      @logger = ::Logger.new(logfile_path, 0)
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      @app = app
    end
    
    def call(env)
      env['thumbs.logger'] = []
      env['thumbs.logger'] << "#{env['thumbs.remote_url']}@#{env['thumbs.size']}"
      response = []
      realtime = Benchmark.realtime do
        response = @app.call(env)
      end
      status, headers, body = response
      env['thumbs.logger'] << sprintf('%.4f', realtime)
      @logger.info env['thumbs.logger'].join(" : ")
      return [status, headers, body]
    end
  end
end