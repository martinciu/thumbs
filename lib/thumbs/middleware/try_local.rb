module Thumbs
  class TryLocal
    
    def initialize(app)
      @app = app
      @local = Rack::File.new(Dir.pwd)
    end

    def call(env)
      status, headers, body = @local.call(env.merge('PATH_INFO' => "/#{env['thumbs.resized_path']}"))
      if status == 404
        status, headers, body = @app.call(env)
      else
        env['thumbs.logger'] << "local_cache"
      end
      [status, headers, body]
    end
  end

end
