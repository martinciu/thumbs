require 'mini_magick'

module Thumbs
  class Resize
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      status, headers, body = @app.call(env)
      if env['thumbs.size']
        new_body = []
        begin
          body.each do |chunk|
            thumb = MiniMagick::Image.read(chunk)
            thumb.resize env['thumbs.size']
            new_body << thumb.to_blob
          end
        rescue
        end
      end
      [status, headers, new_body]
    end
  end
end