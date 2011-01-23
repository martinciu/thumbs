require 'digest/sha1'
module Thumbs

  class Image

    attr_accessor :server, :path, :size

    def initialize(params)
      @size          = params[:size] if params[:size] =~ /^\d+x\d+$/
      @url           = params[:original_url]
      @thumbs_folder = params[:thumbs_folder]
    end

    def local_path(size)
      File.join(@thumbs_folder, spread(sha(size+@url))) if @thumbs_folder
    end
    
    def original_path
      local_path("original")
    end
    
    def resized_path
      local_path(@size)
    end
    
    def remote_url
      "http://#{@url}"
    end
    
    protected
      def sha(path)
        Digest::SHA1.hexdigest(path)
      end
      
      def spread(sha, n = 2)
        sha[2, 0] = "/"
        sha
      end
  end

end
