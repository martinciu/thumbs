require 'ftools'

module Thumbs
  class Cache
    
    def initialize(app, cache_type = "resized")
      @app = app
      @cache_type = cache_type
    end

    def call(env)
      status, headers, body = @app.call(env)

      path   = env["thumbs.#{@cache_type}_path"]

      if status == 200
        File.makedirs(File.dirname(path)) unless File.directory?(File.dirname(path))
        open(path, "w") do |cache_file|
          cache_file.write(body)
        end
      end

      [status, headers, body]
    end
  end

end



