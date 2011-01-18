require 'digest/sha1'
module Thumbs

  class Image

    attr_accessor :server, :path, :size

    def initialize(params)
      @size          = params[:size] if params[:size] =~ /^\d+x\d+$/
      @url           = params[:original_url]
      @root_folder   = params[:root_folder]
    end

    def local_path(size = "original")
      File.join(@root_folder, spread(sha(size+@url))) if @root_folder
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
