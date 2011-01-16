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
  
end


