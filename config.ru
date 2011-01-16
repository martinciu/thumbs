require "rubygems"
require "bundler/setup"

require 'open-uri'
require 'ftools'
require 'mini_magick'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'thumbs'

use Rack::Config do |env|
  env['thumbs.root_folder'] = "public/system/thumbs/"
end

use Rack::Runtime
use Rack::ShowExceptions
use Rack::Reloader

use Thumbs::Config

use Thumbs::ServerName
use Thumbs::CacheControl
use Rack::ETag

use Thumbs::TryLocal

use Thumbs::Cache, "resized"
use Thumbs::Resize

use Thumbs::Cache, "original"
use Thumbs::NotFound

use Rack::ContentType, "image/jpeg"
use Thumbs::Download

run Thumbs::Server.new