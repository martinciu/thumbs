require "rubygems"
require "bundler/setup"

require 'goliath'
require 'em-http'
require 'em-synchrony/em-http'
require 'digest/sha1'
require "em-files"
require 'rack/mime'
require 'lumberjack'

require File.join(File.dirname(__FILE__), '/thumbs/evented_magick')
require File.join(File.dirname(__FILE__), '/thumbs/image')
require File.join(File.dirname(__FILE__), '/thumbs/middleware/content_type')

class Thumbs < Goliath::API
  
  use ::Rack::Runtime

  use Goliath::Rack::Heartbeat          # respond to /status with 200, OK (monitoring, etc)
  use ContentType

  def initialize
    @logger = Lumberjack::Logger.new("logs/thumbs.log", :time_format => "%Y-%m-%d %H:%M:%S", :roll => :daily, :flush_seconds => 5)
  end

  def response(env)
    start_time = Time.now.to_f
    log_message = []
    url_pattern, keys = compile(env.url_map)
    status, headers, boady = [-1, {}, ""]

    if match = url_pattern.match(env['PATH_INFO'])
      values = match.captures.to_a
      params = keys.zip(values).inject({}) do |hash,(k,v)|
        hash[k.to_sym] = v
        hash
      end
      image = Image.new(params.merge(:thumbs_folder => env.thumbs_folder))
      log_message << image.url
      log_message << image.size
    else
      log_message << "invalid_url"
      return not_found
    end

    #cache_resized_read
    if env.cache
      begin
        status, body = 200, File.read(image.resized_path)
        log_message << "resized_cache"
        write_log log_message, start_time
        return [status, headers, body]
      rescue Errno::ENOENT, IOError => e
      end
    end

    #cache_original_read
    if env.cache_original
      begin
        status, body = 200, File.read(image.original_path)
        log_message << "original_cache"
      rescue Errno::ENOENT, IOError => e
      end
    end

    if status < 200
      #download
      log_message << "download"
      original_response = EM::HttpRequest.new(image.remote_url).get :connection_timeout => 5, :inactivity_timeout => 10, :redirects => 0
      status = original_response.response_header.status
      if status >= 200 && status < 300
        status, body = 200, original_response.response
        #cache_original_write
        if cache_original
          path = image.original_path
          tries = 0
          begin
            EM::File.open(path, "wb") {|f| f.write(body) }
          rescue Errno::ENOENT, IOError
            Dir.mkdir(File.dirname(path), 0755)
            retry if (tries += 1) == 1
          end
        end
      else
        status, heders, body = not_found
      end

    end

    #resize
    if status > 0
      thumb = EventedMagick::Image.from_blob(body)
      thumb.resize image.size
      body = thumb.to_blob
    end

    #cache_resized_write
    if env.cache && status >= 200 && status < 300
      path = image.resized_path
      tries = 0
      begin
        EM::File.open(path, "wb") {|f| f.write(body) }
      rescue Errno::ENOENT, IOError
        Dir.mkdir(File.dirname(path), 0755)
        retry if (tries += 1) == 1
      end
    end
    write_log log_message, start_time
    [status, headers, body]
  end

  private

    def compile(url_map)
      keys = []
      pattern = url_map.gsub(/((:\w+))/) do |match|
        keys << $2[1..-1]
        "(.+?)"
      end
      [/^#{pattern}$/, keys]
    end

    def not_found
      [404, {}, File.read(File.expand_path("thumbs/images/image_not_found.jpg", __FILE__))]
    end

    def write_log(message, start_time)
      message << "#{((Time.now.to_f - start_time)*1000).round}ms"
      @logger.info message.join("\t")
    end

end
