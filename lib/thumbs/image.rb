require 'digest/md5'
module Thumbs

  class Image

    attr_accessor :server, :path, :size

    def initialize(params)
      @size          = params[:size] if params[:size] =~ /^\d+x\d+$/
      @server, @path = params[:original_url].split("/", 2)
      @root_folder   = params[:root_folder]
    end

    def local_path(size = "original")
      File.join(@root_folder, @server, size, local_filename.chars.first, local_filename) if @root_folder
    end
    
    def local_filename
      "#{Digest::MD5.hexdigest(@path)}.jpg"
    end
    
    def remote_url
      "http://#{@server}/#{@path}"
    end

  end

end
