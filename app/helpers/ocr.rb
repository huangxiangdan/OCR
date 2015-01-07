module OCR
  # require 'rubygems'
  # require 'mechanize'
  require 'mini_magick'
  require 'rtesseract'

  def preprocess(image_options = [])

    # img.reduce_noise(0)
    # img.crop("#{img[:width] - 2}x#{img[:height] - 2}+1+1") #去掉边框（上下左右各1像素）
    i = 0
    @image.combine_options do |c|
      image_options.each do |hash|
        hash.each do |k, v|
          #hack for mini magick bug
          if v.present? && v.split.length > 1
            c.send(k, nil)
            v.split.each do |param|
              c << param
            end
          else
            c.send(k, v)
          end
        end
      end
    end
  end

  def parse(file_name)
    begin
      puts file_name.inspect
      @image = MiniMagick::Image.new(file_name)  
      preprocess([{"crop" => "90x36+0+0", "white-threshold" => "60%","colorspace"=>"GRAY"}])
      # img.colorspace("GRAY")#灰度化 
      tesseract_options = {"tessedit_char_whitelist" => [*'a'..'z', *0..9].join, "psm" => "7"}
      image = RTesseract.new(@image.path, tesseract_options) 
      image.to_s_without_spaces
    rescue Exception => ex
      puts ex.inspect
      logger.error ex.inspect
    end
  end
end