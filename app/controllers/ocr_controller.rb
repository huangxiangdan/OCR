class OcrController < ApplicationController
  def index
    redirect_to "http://ruiana.com"
  end
  
  def ocr
    result = ""
    if params[:data].present? && params[:finished].blank?
      session[params[:id]] ||= ""
      session[params[:id]] += params[:data]
      render :json => "result = '';"
      return
      # session[:data] = session[:data] ? session[:data] + params[:data] : params[:data]
    else
      session[params[:id]] ||= ""
      session[params[:id]] += params[:data] if params[:data].present?
      file_name = params[:id] + '.jpg'
      File.open(file_name, 'wb') do|f|
        f.write(Base64.decode64(session[params[:id]]))
        f.close
      end
      # puts "test2"
      session[:data] = nil
      puts file_name
      ocr = OCR.new(file_name)
      method = params[:ocr_method] || :parse
      puts method.inspect
      result = ocr.send method
      # puts result
      
      # File.delete(file_name)
      puts "result:#{result}"
      unless result.match(/^\w{4}$/)
        result = ''
      end
    end
    render :json => "result='#{result}'"
  end

  def open
    `open #{params["url"]}`
    render :json => "result=true"
  end

  def proxy
    render :text => "helloworld"
  end

  def context
    context = $redis.get("jimubox_context")
    render :json => "context='#{context}'"
  end

  def jimu_ocr
    cookie_str = params[:cookies]
    # unless cookie_str
    #   cookie_str =<<-STR
    #     tr=5aff9650-3753-4559-bbce-874ce63eb58c; SpecialCookieID=5062cdc0-f547-475c-bc6c-4cc93413d556; UserCookieID=0798c4c2-d16d-404d-9f18-50a01b256ca8; UserSource2="http://www.jimubox.com/User/Register?landing=ALanding&f=baidu_sem&src=Baidu&medium=PPC&Network=1&kw=5714106128&ad=1470129275&site=&utm_source=baidu&utm_medium=cpc&utm_term=%e7%a7%af%e6%9c%a8%e7%9b%92%e5%ad%90%e5%ae%98%e7%bd%91&utm_content=%e5%93%81%e7%89%8c-%e6%a0%b8%e5%bf%83_pm&utm_campaign=%e5%93%81%e7%89%8c%e8%af%8d_pm&ag_kwid=871-1-d32c9f768061491b.af2e6c5d1085cd1c"; RecommendMode=1; RecommendBy=281843; RecommendAt="2014-12-27 15:22:25"; pgv_pvi=3505423360; UserSourceAt="2014-12-27 16:18:02"; UserChannel=baidu; _jzqy=1.1419574368.1419668284.2.jzqsr=baidu|jzqct=%E7%A7%AF%E6%9C%A8%E7%9B%92%E5%AD%90%E5%AE%98%E7%BD%91.jzqsr=baidu|jzqct=%E7%A7%AF%E6%9C%A8%E7%9B%92%E5%AD%90; _jzqx=1.1419657471.1420469470.16.jzqsr=bbs%2Ejimubox%2Ecom|jzqct=/forum%2Ephp.jzqsr=jimubox%2Ecom|jzqct=/project/index/18667; bs=8a5bb00e-091a-4c9b-b1bb-296d26e1b84f-w; _ga=GA1.2.853931510.1419574369; __ag_cm_=1420784658895; _jzqckmp=1; JSESSIONID=0B820B86A8B34E2DA780C2A4126E39B8; .JM.AUTH=cS5EHHhVRDkRALz1NGypvD12wv9qaoM3qEy5CvNrqqTa/WwEBBsMxb1XPwvFCObaeNWOcDecKGm7dXV4GGdXww; ForumTicket=MS4wfDYyODk5MXxTdG9uZWR8fDIwMTUtMDEtMTFUMjA6Mjg6NTJafDdBSklGWGJMTWxISW5BV29nYUVTbFE9PXw3NzdFOTVCQ0I0RTBBQzcxRjY5OENBQjMwM0U5QzUyOTY5MERBQzhE; juhs=397ad97e; UserSource="http://bbs.jimubox.com/list.php"; Hm_lvt_3dd9747b06b07704cef279b2ed74350f=1420962902,1420963120,1420963849,1420979502; Hm_lpvt_3dd9747b06b07704cef279b2ed74350f=1420980730; __utma=269673834.853931510.1419574369.1420815506.1420863683.58; __utmb=269673834.500.10.1420863683; __utmc=269673834; __utmz=269673834.1419915913.19.7.utmcsr=bbs.jimubox.com|utmccn=(referral)|utmcmd=referral|utmcct=/forum.php; _qzja=1.1388070541.1419574368464.1420815505507.1420863683032.1420980713398.1420980730021.4fb7c3edbc8ba3f075854b0717192f5e.1.0.6258.61; _qzjb=1.1420863683032.851.0.0.0; _qzjc=1; _qzjto=761.0.0; _jzqa=1.2173228284403140900.1419574368.1420815506.1420863683.61; _jzqc=1; _jzqb=1.500.10.1420863683.1; ag_fid=V4aJH8N6eyEVZswF; ag_count=6258
    #   STR
    # end
    url = params["captcha_url"]
    uri = URI.parse(url)
    cookies = cookie_str.split(";")
    agent = Mechanize.new
    map = {}
    cookies.each do |c|
      arr = c.strip.split("=")
      map[arr[0]] = arr[1]
    end
    logger.error map.inspect
    #   arr = c.strip.split("=")
    #   # logger.error arr.inspect
    #   cookie = Mechanize::Cookie.new(:name => arr[0], :value => arr[1], :domain => uri.host, :path => "/", :for_domain => true)
    #   # cookie.for_domain = true
    #   # logger.error cookie.inspect
    #   agent.cookie_jar.add URI.parse("https://www.jimubox.com"), cookie
    # end
    # logger.error agent.cookie_jar.to_a.inspect
    # logger.error agent.cookies.to_s
    logger.error agent.get("https://www.jimubox.com").inspect
    # agent.cookie_jar["UserCookieID"] = "b621d49d-ce02-4595-9c3a-6e210e547522"
    c = agent.cookie_jar.to_a.detect{|c| c.name == "UserCookieID"}
    c.value = map["UserCookieID"]
    c = agent.cookie_jar.to_a.detect{|c| c.name == "tr"}
    c.value = map["tr"]
    c = agent.cookie_jar.to_a.detect{|c| c.name == "bs"}
    c.value = map["bs"]
    # logger.error agent.cookies.to_s
    # logger.error agent.get("https://www.jimubox.com").inspect
    # logger.error agent.cookies.to_s
    res = agent.get(url)
    content = res.content.is_a?(String) ? res.content : res.content.read
    # tempfile = Tempfile.new(['xx', '.jpg'], '/tmp')
    tempfile = File.open("xxx", 'wb')
    tempfile.syswrite(content)
    tempfile.rewind
    result = parse(tempfile.path)
    puts result
    render :json => "result='#{result}'"
  end
end
