module Thumbs

  class NotFound
    F = ::File
    
    def initialize(app, image_not_found = "public/images/image_not_found.jpg")
      @app = app
      file = F.expand_path(image_not_found)
      @content = F.read(file)
    end

    def call(env)
      status, headers, body = @app.call(env)
      if status == 200
        [status, headers, body]
      else
        [404, {}, @content]
      end
    end
    
  end

end