module Thumbs

  class Server
    
    URL_MAP = /^\/(\d+x\d+)\/(.+?)\/(.+)$/
 
    def call(env)
      if env['PATH_INFO'] =~ URL_MAP
        [200, {}, ["Found"]]
      else
        [404, {}, ["Not found"]]
      end
      
    end

  end

end
