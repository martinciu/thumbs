module Thumbs
  class CacheRead
    
    def initialize(app, cache_type = "resized")
      @app = app
      @cache_type = cache_type
    end

    def call(env)
      if env["thumbs.#{@cache_type}_path"]
        begin
          status, headers, body = [200, {}, File.read(env["thumbs.#{@cache_type}_path"])]
          env['thumbs.logger'] << "#{@cache_type}_cache" if env['thumbs.logger']
          return [status, headers, body]
        rescue Errno::ENOENT, IOError => e
        end
      end
      return @app.call(env)
    end
  end

end
