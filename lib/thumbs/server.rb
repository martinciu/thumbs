module Thumbs

  class Server
    
    def call(env)
      if env['PATH_INFO'] =~ env['thumbs.url_pattern']
        [200, {}, ["Found"]]
      else
        [404, {}, ["Not found"]]
      end
      
    end

  end

end
