require 'open-uri'

module Thumbs
  class Download
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if File.exist?(env['thumbs.original_path'])
        [200, {}, open(env['thumbs.original_path']).read]
      else 
        begin
          [200, {}, open(env['thumbs.remote_url']).read]
        rescue StandardError, Timeout::Error => e
          [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
        end
      end
    end
    
  end
end