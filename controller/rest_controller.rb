class RestController
  def RestController.handle(params, sinatraApp)
    sinatraApp.content_type :json
    call_method = params[:method]
    if RestController.respond_to?("#{call_method}")
      return RestResponse.ACCESS_DENIED.to_json if !["login", "logout"].include?(call_method) && sinatraApp.session[:username] == nil
      begin
        return RestController.send("#{call_method}", params, sinatraApp)
      rescue Exception => e
        return RestResponse.UNEXPECTED_ERROR(e)
      end
    else
      RestResponse.INVALID_METHOD.to_json
    end
  end

  def RestController.logout(params, sinatraApp)
    sinatraApp.session.clear
    RestResponse.LOGOUT_OK.to_json
  end

  def RestController.delete_page(params, sinatraApp)
    url_mapping = params[:url_mapping]
    if url_mapping == nil
      return RestResponse.INVALID_ARGUMENTS.to_json
    end
    page = Page.find(:first, :conditions => {:url_mapping => url_mapping})
    if page == nil
      return RestResponse.PAGE_OPERATION_FAILED.to_json
    end
    page.destroy
    RestResponse.PAGE_OPERATION_OK.to_json
  end

  def RestController.query_pages(params, sinatraApp)
    page_url_contains = params[:page_url_contains]
    current_page = params[:current_page]
    items_per_page = params[:items_per_page]
    if page_url_contains == nil || page_number = nil || items_per_page == nil
      return RestResponse.INVALID_ARGUMENTS.to_json
    end
    query_offset = current_page.to_i * items_per_page.to_i
    pages = Page.where(["url_mapping like ?", "%#{page_url_contains}%"])\
      .limit(items_per_page).offset(query_offset)
    puts pages.count
    return RestResponse.QUERY_PAGES(pages).to_json
  end

  def RestController.login(params, sinatraApp)
    username = params[:username]
    password = params[:password]
    if username == nil || password == nil
      return RestResponse.INVALID_ARGUMENTS.to_json
    end
    admin = Admin.find(:first, :conditions => {:username => username, :password => password})
    if admin != nil
      admin.last_login = Time.now
      admin.save
      sinatraApp.session[:username] = admin.username
      return RestResponse.LOGIN_OK.to_json
    else
      return RestResponse.LOGIN_FAILED.to_json
    end
  end
end

class RestResponse
  attr_accessor :data,\
    :response_code,\
    :response_msg

  def initialize(response_code, response_msg, data)
    self.response_code = response_code
    self.response_msg = response_msg
    self.data = data
  end

  def self.to_json
    JSON.dump({
      "response_code" => self.response_code,
      "response_msg" => self.response_msg,
      "data" => self.data
    })
  end

  def RestResponse.INVALID_METHOD
    return RestResponse.new(-1, "Invalid method.", nil)
  end

  def RestResponse.INVALID_ARGUMENTS
    return RestResponse.new(-2, "Invalid arguments.", nil)
  end

  def RestResponse.LOGIN_FAILED
    return RestResponse.new(-3, "Login failed, please check username and password.", nil)
  end

  def RestResponse.UNEXPECTED_ERROR(e)
    return RestResponse.new(-4, "Unexcepted error: #{e.to_s}.", nil)
  end

  def RestResponse.PAGE_OPERATION_FAILED
    return RestResponse.new(-5, "Page operation failed.", nil)
  end

  def RestResponse.ACCESS_DENIED
    return RestResponse.new(-6, "Access denied because not login or session expires.", nil)
  end

  def RestResponse.LOGIN_OK
    return RestResponse.new(0, "Login succeed.", nil)
  end

  def RestResponse.QUERY_PAGES(data)
    return RestResponse.new(1, "Query pages succeed.", data)
  end

  def RestResponse.PAGE_OPERATION_OK
    return RestResponse.new(2, "Page operation succeed.", nil)
  end

  def RestResponse.LOGOUT_OK
    return RestResponse.new(3, "Logout succeed.", nil)
  end
end