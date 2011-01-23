module Thumbs
  class TryLocal
    
    def initialize(app)
      @app = app
      @local = Rack::File.new(Dir.pwd)
    end

    def call(env)
      status, headers, body = @local.call(env.merge('PATH_INFO' => "/#{env['thumbs.local_path']}"))
      if status == 404
        status, headers, body = @app.call(env)
      end
      env['thumbs.logger'] << "local_cache"
      [status, headers, body]
    end
  end

end
