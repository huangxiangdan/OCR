class OCR
  # require 'rubygems'
  # require 'mechanize'
  require 'mini_magick'
  require 'rtesseract'

  def initialize(file_name)
    puts file_name.inspect
    @file_name = file_name
    @image = MiniMagick::Image.new(file_name)
  end

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

  def parse
    begin
      # preprocess([{"crop" => "90x36+0+0", "white-threshold" => "60%","colorspace"=>"GRAY"}])
      preprocess([{"crop" => "90x36+0+0", "white-threshold" => "60%", "scale" => "200%", "morphology" => "Dilate Diamond", "colorspace"=>"GRAY", "monochrome"=>nil}, {"scale" => "50%"}, {"scale" => "200%", "morphology" => "Dilate Diamond", "colorspace"=>"GRAY"}])
      # img.colorspace("GRAY")#灰度化 
      tesseract_options = {"tessedit_char_whitelist" => ['a', 'b', 'd', 'e', 'f', 'g', 'j', 'm', 'n', 'p', 'r', 't', 'w', 'y', 3, 4, 6, 7, 8].join, "psm" => "7"}
      image = RTesseract.new(@image.path, tesseract_options) 
      image.to_s_without_spaces
    rescue Exception => ex
      puts ex.inspect
      logger.error ex.inspect if defined? logger
      ''
    end
  end

  def zhengfang_ocr
    image_options = []
    image = Magick::ImageList.new(@file_name).first
    if image.present?
      if image.columns == 72 && image.rows == 27
        image_options = [{"crop" => "70x25+1+1", "scale" => "200%", "morphology" => "Dilate Diamond"}, {"scale" => "50%", "fuzz" => "55%"}, {"colorspace"=>"GRAY", "monochrome"=>nil}]
      elsif image.columns == 48 && image.rows == 22
        image_options = [{"crop" => "46x20+1+1" , "white-threshold" => "48%", "scale" => "400%", "morphology" => "Dilate Diamond"}, {"scale" => "25%", "white_threshold" => "90%"}, {"colorspace"=>"GRAY", "monochrome"=>nil}]
      end
    end
    preprocess(image_options)
    tesseract_options = {"tessedit_char_whitelist" => [*'a'..'z', *0..9].join, "psm" => "7"}
    image = RTesseract.new(@image.path, tesseract_options)
    image.to_s_without_spaces
  end

  def self.generate(captcha_url, foldername = "captchas")
    # captcha_url = "https://www.jimubox.com/CaptchaImage"

    agent = Mechanize.new
    map = {}
    if File.exist?("./test/#{foldername}")
      puts "#{foldername} already exist"
      return
    end
    100.times do |i|
      filename = "#{foldername}#{i}.png"
      path = "./test/#{foldername}/#{filename}"
      agent.get(captcha_url).save(path)
      `open #{path}`
      print "请输入第#{i}个验证码："
      map[filename] = STDIN.gets.chomp
      puts map.inspect
    end
  end
end