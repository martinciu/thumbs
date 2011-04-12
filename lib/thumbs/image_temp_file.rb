require "tempfile"

module EventedMagick
  class ImageTempFile < Tempfile
    def make_tmpname(ext, n)
      "mini_magick-#{Time.now.to_i}-#{$$}-#{rand(0x10000000)}"
    end
  end
end
