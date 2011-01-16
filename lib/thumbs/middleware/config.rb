module Thumbs
  class Config

    def initialize(app, url_map)
      @app = app
      @url_pattern, @keys = compile(url_map)
    end

    def call(env)
      env['thumbs.url_pattern'] = @url_pattern
      if match = @url_pattern.match(env['PATH_INFO'])
        values = match.captures.to_a
        params = @keys.zip(values).inject({}) do |hash,(k,v)|
          hash[k.to_sym] = v
          hash
        end

        image = Image.new(params.merge(:root_folder => env['thumbs.root_folder']))

        env['thumbs.remote_url']      = image.remote_url
        env['thumbs.resized_path']    = image.local_path(image.size)
        env['thumbs.original_path']   = image.local_path
        env['thumbs.size']            = image.size

        @app.call(env)
      else
        [404, {'Content-Type' => "text/plain"}, ["Not found"]]
      end
    end

    protected
      def compile(url_map)
        keys = []
        pattern = url_map.gsub(/((:\w+))/) do |match|
          keys << $2[1..-1]
          "(.+?)"
        end
        [/^#{pattern}$/, keys]
      end

  end

end
