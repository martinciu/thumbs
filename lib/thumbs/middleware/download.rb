require 'open-uri'

module Thumbs
  class Download
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['thumbs.remote_url']
        begin
          status, headers, body = [200, {}, open(env['thumbs.remote_url']).read]
          env['thumbs.logger'] << "download" if env['thumbs.logger']
          return [status, headers, body]
        rescue StandardError, Timeout::Error => e
          status, headers, body = [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
          env['thumbs.logger'] << "not_found" if env['thumbs.logger']
          return [status, headers, body]
        end
      else
        return @app.call(env)
      end
    end
    
  end
end