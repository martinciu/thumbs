require 'open-uri'

module Thumbs
  class Download
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['thumbs.original_path']
        begin
          [200, {}, File.open(env['thumbs.original_path']).read]
        rescue Errno::ENOENT, IOError
        end
      else
        if env['thumbs.remote_url']
          begin
            [200, {}, open(env['thumbs.remote_url']).read]
          rescue StandardError, Timeout::Error => e
            [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
          end
        else
          @app.call(env)
        end
      end
    end
    
  end
end