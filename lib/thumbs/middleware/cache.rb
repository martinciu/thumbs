module Thumbs
  class Cache
    
    def initialize(app, cache_type = "resized")
      @app = app
      @cache_type = cache_type
    end

    def call(env)
      status, headers, body = @app.call(env)

      path = env["thumbs.#{@cache_type}_path"]

      if path && status == 200
        tries = 0
        begin
          File.open(path, "wb") {|f| f.write(body) }
        rescue Errno::ENOENT, IOError
          Dir.mkdir(File.dirname(path), 0755)
          retry if (tries += 1) == 1
        end
      end

      [status, headers, body]
    end
    
  end

end



