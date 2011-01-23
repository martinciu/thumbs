module Thumbs
  class CacheControl
    def initialize(app, options)
      @app           = app
      @ttl           = options[:ttl] || 86400
      @last_modified = options[:last_modified].nil? ? true : options[:last_modified]
    end
    
    def call(env)
      status, headers, body = @app.call(env)
      headers['Cache-Control'] ||=  "max-age=#{@ttl}, public"
      headers['Expires']       ||= (Time.now + @ttl).httpdate
      headers['Last-Modified'] ||= Time.now.httpdate if @last_modified
      [status, headers, body]
    end
  end
end