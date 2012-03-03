module OCR
  # require 'rubygems'
  # require 'mechanize'
  require 'mini_magick'
  require 'rtesseract'

  def parse(file_name)
    begin
      img = MiniMagick::Image.new(file_name)  
      img.colorspace("GRAY")#灰度化 
      image = RTesseract.new(img.path) 
      image.to_s.sub(/\s+$/, "")
    rescue Exception => ex
      logger.error ex.inspect
    end
  end
end