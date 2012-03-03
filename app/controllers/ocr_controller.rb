class OcrController < ApplicationController
  include OCR
  def index
    redirect_to "http://ruiana.com"
  end
  
  def ocr
    result = ""
    if params[:data]
      session[:data] = session[:data] ? session[:data] + params[:data] : params[:data]
      render :json => "result = '';"
      return
      # session[:data] = session[:data] ? session[:data] + params[:data] : params[:data]
    else
      file_name = request.session_options[:id] + '.jpg'
      File.open(file_name, 'wb') do|f|
        f.write(Base64.decode64(session[:data]))
        f.close
      end
      puts "test2"
      session[:data] = nil
      result = parse(file_name)
      
      # File.delete(file_name)
      puts "result:#{result}"
      unless result.match(/^\w{4}$/)
        result = ''
      end
    end
    render :json => "result='#{result}'"
  end
end
