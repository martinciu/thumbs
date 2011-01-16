require "rubygems"
require "bundler/setup"

module Thumbs
  autoload :Server,       'thumbs/server'
  autoload :Image,        'thumbs/image'
  autoload :TryLocal,     'thumbs/middleware/try_local'
  autoload :NotFound,     'thumbs/middleware/not_found'
  autoload :ServerName,   'thumbs/middleware/server_name'
  autoload :CacheControl, 'thumbs/middleware/cache_control'
  autoload :Download,     'thumbs/middleware/download'
  autoload :Resize,       'thumbs/middleware/resize'
  autoload :Config,       'thumbs/middleware/config'
  autoload :Cache,        'thumbs/middleware/cache'
  
  def self.new(*args)
    app = args.shift if args.first.respond_to?(:call)
    options = {
      :thumbs_folder   => File.join(File.dirname(__FILE__), "..", "public", "system", "thumbs"),
      :etag            => true,
      :cache           => true,
      :cache_original  => true,
      :default_ttl     => 86400,
      :server_name     => "Thumbs/0.0.1 (https://github.com/martinciu/thumbs)",
      :url_map         => "/:size/:original_url",
      :image_not_found => File.join(File.dirname(__FILE__), "..", "public", "images", "image_not_found"),
      :runtime         => RACK_ENV == 'development'
    }.merge!(args.first)
    
    Rack::Builder.new do
      
      use Rack::Runtime if options[:runtime]
      
      use Rack::Config do |env|
        env['thumbs.root_folder'] = options[:thumbs_folder]
      end
      
      if RACK_ENV == 'development'
        use Rack::ShowExceptions
        use Rack::Reloader
      end

      use Thumbs::Config, options[:url_map]

      use Thumbs::ServerName, options[:server_name] if options[:server_name]
      use Thumbs::CacheControl, options[:default_ttl] if options[:default_ttl]
      use Rack::ETag if options[:etag]

      if options[:cache]
        use Thumbs::TryLocal
        use Thumbs::Cache, "resized"
      end
      
      use Thumbs::Resize

      use Thumbs::Cache, "original" if options[:cache_original]
      use Thumbs::NotFound, options[:image_not_found] if File.exist?(options[:image_not_found])

      use Rack::ContentType, "image/jpeg"
      use Thumbs::Download

      run Thumbs::Server.new
    end
  end
  
end
