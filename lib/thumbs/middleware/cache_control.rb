module Thumbs
  class CacheControl
    def initialize(app, ttl)
      @app = app
      @ttl = ttl
    end
    
    def call(env)
      status, headers, body = @app.call(env)
      headers['Cache-Control'] ||=  "max-age=#{@ttl}, public"
      headers['Expires']       ||= (Time.now + @ttl).httpdate
      headers['Last-Modified'] ||= Time.now.httpdate
      [status, headers, body]
    end
  end
end