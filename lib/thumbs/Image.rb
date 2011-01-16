require 'digest/md5'

module Thumbs

  class Image

    attr_accessor :server, :path, :size

    def initialize(env)
      matches = /^\/(\d+x\d+)\/(.+?)\/(.+)$/.match(env['PATH_INFO'])
      if matches
        @size          = matches[1]
        @server        = matches[2]
        @path          = matches[3]
        @root_folder   = env["thumbs.root_folder"]
      end
    end

    def local_path(size = "original")
      File.join(@root_folder, @server, size, local_filename.chars.first, local_filename)
    end
    
    def local_filename
      "#{Digest::MD5.hexdigest(@path)}.jpg"
    end
    
    def remote_url
      "http://#{@server}/#{@path}"
    end

  end

end
