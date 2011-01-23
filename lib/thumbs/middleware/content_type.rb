require 'rack/mime'

module Thumbs
  class ContentType
    def initialize(app, default_content_type = "image/jpeg")
      @app = app
      @default_content_type = default_content_type
    end
    
    def call(env)
      status, headers, body = @app.call(env)
      headers['Content-Type'] = Rack::Mime.mime_type(File.extname(env["thumbs.remote_url"]), @default_content_type) if headers['Content-Type'].nil?
      [status, headers, body]
    end
  end
end