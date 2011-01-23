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
  autoload :Logger,       'thumbs/middleware/logger'
  
  def self.new(args)
    options = {
      :thumbs_folder   => false,
      :etag            => true,
      :cache           => true,
      :cache_original  => true,
      :default_ttl     => 86400,
      :server_name     => "Thumbs/0.0.1 (https://github.com/martinciu/thumbs)",
      :url_map         => "/:size/:original_url",
      :image_not_found => File.join(File.dirname(__FILE__), "thumbs", "images", "image_not_found.jpg"),
      :runtime         => false,
      :logfile         => "log/thumbs.log"
    }.merge!(args)
    
    Rack::Builder.new do
      
      use Rack::Runtime if options[:runtime]
      
      use Rack::Config do |env|
        env['thumbs.thumbs_folder'] = options[:thumbs_folder]
      end
      
      use Rack::ShowExceptions

      use Thumbs::Config, options[:url_map]
      
      use Thumbs::Logger, options[:logfile]

      use Thumbs::ServerName, options[:server_name] if options[:server_name]
      use Thumbs::CacheControl, options[:default_ttl] if options[:default_ttl]
      use Rack::ETag if options[:etag]

      if options[:cache] && options[:thumbs_folder] && File.exist?(File.expand_path(options[:thumbs_folder]))
        use Thumbs::TryLocal
        use Thumbs::Cache, "resized"
      end
      
      use Thumbs::Resize

      use Thumbs::Cache, "original" if options[:cache_original] && options[:thumbs_folder] && File.exist?(File.expand_path(options[:thumbs_folder]))

      use Rack::ContentType, "image/jpeg"
      use Thumbs::NotFound, options[:image_not_found] if options[:image_not_found] && File.exist?(File.expand_path(options[:image_not_found]))

      use Thumbs::Download

      run Thumbs::Server.new
    end
  end
  
end
