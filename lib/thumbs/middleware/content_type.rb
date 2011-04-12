class ContentType
  def initialize(app, default_content_type = "image/jpeg")
    @app = app
    @default_content_type = default_content_type
  end

  def call(env)
    async_cb = env['async.callback']
    env['async.callback'] = Proc.new do |status, headers, body|
      async_cb.call(post_process(status, headers, body, env))
    end

    status, headers, body = @app.call(env)
    post_process(status, headers, body, env)
  end

  def post_process(status, headers, body, env)
    headers['Content-Type'] = Rack::Mime.mime_type(File.extname(env["PATH_INFO"]), @default_content_type) if headers['Content-Type'].nil?
    [status, headers, body]
  end
end
