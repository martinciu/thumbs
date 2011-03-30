$: << File.expand_path("../../lib", __FILE__)
require "rubygems"
require "thumbs"

run Thumbs.new(
  :url_map         => "/:size/:original_url", # url pattern, :original_url is required
  :thumbs_folder   => "cache", # default: false - do not write on disk
  :cache           => true,                   # cache resized images - has no effect unless thumbs_folder exist
  :cache_original  => true,                   # cache original images - has no effect unless thumbs_folder exist
  :runtime         => true,                   # add X-Runtime header
  :cache_control => {
    :ttl           => 86400,                  # add Expires and Cache-Control header for 24h
    :last_modified => true                    # add Last-Modfied header
  },
  :etag            => true,                   # add ETag
  :logfile         => false,                  # will write log file if filepath is provided
  :server_name     => "Thumbs/0.0.8",         # Server header
  :image_not_found => "image_not_found.jpg"   # path to image_not_found
)
