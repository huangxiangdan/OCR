class OcrController < ApplicationController
  include OCR
  def index
    redirect_to "http://ruiana.com"
  end
  
  def ocr
    result = ""
    if params[:data].present?
      session[params[:id]] ||= ""
      session[params[:id]] += params[:data]
      render :json => "result = '';"
      return
      # session[:data] = session[:data] ? session[:data] + params[:data] : params[:data]
    else
      file_name = params[:id] + '.jpg'
      File.open(file_name, 'wb') do|f|
        f.write(Base64.decode64(session[params[:id]]))
        f.close
      end
      puts "test2"
      session[:data] = nil
      puts file_name
      result = parse(file_name)
      puts result
      
      # File.delete(file_name)
      puts "result:#{result}"
      unless result.match(/^\w{4}$/)
        result = ''
      end
    end
    render :json => "result='#{result}'"
  end
end
