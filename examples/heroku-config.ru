$: << File.expand_path("../../lib", __FILE__)
RACK_ENV = ENV['RACK_ENV'] || 'development'

require "rubygems"
require "bundler/setup"

require 'thumbs'

run Thumbs.new(:url_map => "/i/:size/:original_url")

