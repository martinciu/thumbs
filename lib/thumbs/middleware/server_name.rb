module Thumbs
  class ServerName
    def initialize(app, server_name = "Thumbs/0.0.1 (https://github.com/martinciu/thumbs)")
      @app = app
      @server_name = server_name
    end
    
    def call(env)
      status, headers, body = @app.call(env)
      headers['Server'] = @server_name
      [status, headers, body]
    end
  end
end