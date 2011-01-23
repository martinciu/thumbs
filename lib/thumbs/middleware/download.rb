require 'open-uri'

module Thumbs
  class Download
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['thumbs.original_path']
        begin
          status, headers, body = [200, {}, File.open(env['thumbs.original_path']).read]
          env['thumbs.logger'] << "original_cache"
          return [status, headers, body]
        rescue Errno::ENOENT, IOError => e
        end
      end
      if env['thumbs.remote_url']
        begin
          status, headers, body = [200, {}, open(env['thumbs.remote_url']).read]
          env['thumbs.logger'] << "download"
          return [status, headers, body]
        rescue StandardError, Timeout::Error => e
          status, headers, body = [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
          env['thumbs.logger'] << "not_found"
          return [status, headers, body]
        end
      else
        return @app.call(env)
      end
    end
    
  end
end