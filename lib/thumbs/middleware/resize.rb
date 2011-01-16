module Thumbs
  class Resize
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      status, headers, body = @app.call(env)

      if(headers["Content-Type"] == "image/jpeg")
        thumb = MiniMagick::Image.read(body)
        thumb.resize env['thumbs.size']
      
        [status, headers, thumb.to_blob]
      else
        [status, headers, body]
      end
    end
  end
end