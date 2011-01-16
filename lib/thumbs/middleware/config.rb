module Thumbs
  class Config

    def initialize(app)
      @app = app
      @local = Rack::File.new(Dir.pwd)
    end

    def call(env)
      if env['PATH_INFO'] =~ Thumbs::Server::URL_MAP
        image = Image.new(env)
        
        env['thumbs.remote_url']      = image.remote_url
        env['thumbs.resized_path']    = image.local_path(image.size)
        env['thumbs.original_path']   = image.local_path
        env['thumbs.size']            = image.size

        @app.call(env)
      else
        [404, {'Content-Type' => "text/plain"}, ["Not found"]]
      end
    end

  end

end
