require 'open-uri'

module Thumbs
  class Download
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['thumbs.original_path']
        begin
          return [200, {}, File.open(env['thumbs.original_path']).read]
        rescue Errno::ENOENT, IOError => e
        end
      end
      if env['thumbs.remote_url']
        begin
          return [200, {}, open(env['thumbs.remote_url']).read]
        rescue StandardError, Timeout::Error => e
          return [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
        end
      else
        return @app.call(env)
      end
    end
    
  end
end