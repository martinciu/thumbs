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
        
        image = Image.new(params.merge(:thumbs_folder => env['thumbs.thumbs_folder']))

        env['thumbs.remote_url']      = image.remote_url
        env['thumbs.url']             = image.url
        env['thumbs.resized_path']    = image.resized_path
        env['thumbs.original_path']   = image.original_path
        env['thumbs.size']            = image.size
      end
      @app.call(env)
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
