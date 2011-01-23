require 'mini_magick'

module Thumbs
  class Resize
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      status, headers, body = @app.call(env)

      if env['thumbs.size']
        begin
          thumb = MiniMagick::Image.read(body)
          thumb.resize env['thumbs.size']
          body = thumb.to_blob
        rescue
        end
      end

      [status, headers, body]
    end
  end
end