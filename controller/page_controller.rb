include Rack::Utils

class PageController
  def PageController.urlSuffixAjax(params, sinatraApp)
    page_pk = params[:url_mapping]
    return Page.count(:conditions => {:url_mapping => page_pk}).to_s
  end

  def PageController.create(params, sinatraApp)
    urlMapping = params[:url_suffix]
    displayName = params[:page_name]
    yourName = params[:your_name]
    loverName = params[:lover_name]
    startTime = params[:start_time]
    deleteKey = params[:delete_key]
    yourWords = params[:your_words]
    interval = params[:interval]
    typewriterSpeed = params[:typewriter_speed]
    loveheartSpeed = params[:loveheart_speed]
    signatureInterval = params[:signature_interval]
    wordsInterval = params[:words_interval]
    reasons = []
    if (urlMapping =~ /^\w{1,32}$/) == nil
      reasons << "URL suffix not valid!"
    end
    if (displayName =~ /^.{1,32}$/) == nil
      reasons << "Display name not valid!"
    end
    if (yourName =~ /^.{1,32}$/) == nil
      reasons << "Your name not valid!"
    end
    if (loverName =~ /^.{1,32}$/) == nil
      reasons << "Lover name not valid!"
    end
    if (startTime =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/) == nil
      reasons << "Start time not valid!"
    end
    if (deleteKey =~ /^.{6,16}$/) == nil
      reasons << "Delete key not valid!"
    end
    if (yourWords =~ /^[\s\S]{1,4096}$/s) == nil
      reasons << "Your words not valid!"
    end
    if (interval =~ /^\d{1,4}$/) == nil
      reasons << "Animation interval not valid!"
    end
    if (typewriterSpeed =~ /^\d{1,4}$/) == nil
      reasons << "Typewriter speed not valid!"
    end
    if (loveheartSpeed =~ /^\d{1,4}$/) == nil
      reasons << "Love heart speed not valid!"
    end
    if (signatureInterval =~ /^\d{1,4}$/) == nil
      reasons << "Signature interval not valid!"
    end
    if (wordsInterval =~ /^\d{1,4}$/) == nil
      reasons << "Words interval not valid!"
    end
    if reasons.empty?
      page = Page.new :url_mapping => urlMapping, :display_name => displayName, :your_name => yourName,\
        :lover_name => loverName, :start_time => startTime, :page_key => Digest::SHA1.hexdigest(deleteKey),\
        :message => yourWords, :interval => interval, :loveheart_speed => loveheartSpeed, :words_interval => wordsInterval,\
        :typewriter_speed => typewriterSpeed,  :signature_interval => signatureInterval
      begin
        page.save!
        sinatraApp.redirect("/page/#{urlMapping}")
      rescue Exception
        sinatraApp.erb :error, :locals => {:error_title => "Cannot save page", \
                                           :error_content =>"Cannot save page to database due to duplicate URL mapping."}
      end
    else
      sinatraApp.erb :error, :locals => {:error_title => "Invalid parameters", \
                                         :error_content => reasons.join("<br/>")}
    end
  end

  def PageController.render(params, sinatraApp)
    page_pk = params[:url_mapping]
    page = Page.find(:first, :conditions => {:url_mapping => page_pk})
    if page == nil
      return sinatraApp.erb(:error, :locals => {:error_title => "Page not found", \
                                                :error_content => "Could not find page with URL mapping \"" + page_pk +"\""})
    end
    page.view_count += 1
    page.save
    return self.renderInternal(page, sinatraApp)
  end

  def self.renderInternal(page, sinatraApp)
    page_params = {
      :url_mapping => escape_html(page.url_mapping),
      :display_name => escape_html(page.display_name),
      :your_words => PageController.decorateCode(page.message),
      :lover_name => escape_html(page.lover_name),
      :your_name => escape_html(page.your_name),
      :display_name => escape_html(page.display_name),
      :start_time => page.start_time.strftime("%Y-%m-%d %H:%M:%S"),
      :created_at => page.created_at.strftime("%Y-%m-%d %H:%M:%S"),
      :view_count => page.view_count,
      :interval => page.interval,
      :typewriter_speed => page.typewriter_speed,
      :loveheart_speed => page.loveheart_speed,
      :signature_interval => page.signature_interval,
      :words_interval => page.words_interval
    }
    return sinatraApp.erb(:love, :locals => page_params)
  end

  def PageController.renderIndex(sinatraApp)
    PageController.render({:url_mapping => "hackerzhou"}, sinatraApp)
  end

  def PageController.preview(req, sinatraApp)
    page = Page.new :display_name => req.cookies["page_name"],\
      :your_name => req.cookies["your_name"],\
      :lover_name => req.cookies["lover_name"],\
      :start_time => req.cookies["start_time"],\
      :message => req.cookies["your_words"],\
      :interval => req.cookies["interval"],\
      :created_at => Time.now,\
      :view_count => 1,\
      :typewriter_speed => req.cookies["typewriter_speed"],\
      :loveheart_speed => req.cookies["loveheart_speed"],\
      :words_interval => req.cookies["words_interval"],\
      :signature_interval => req.cookies["signature_interval"]
    self.renderInternal(page, sinatraApp)
  end

  def PageController.delete(params, sinatraApp)
    page_pk = params[:url_mapping]
    page_remove_key = params[:page_remove_key]
    page = Page.find(page_pk)
    if page == nil
      return sinatraApp.erb(:error, :locals => {:error_title => "Page not found", \
                                                :error_content => "Could not find page with URL mapping #{page_pk}"})
    end
    if page_remove_key == nil || page.page_key != Digest::SHA1.hexdigest(page_remove_key)
      return sinatraApp.erb(:error, :locals => {:error_title => "Incorrect page remove key", \
                                                :error_content => "You cannot delete page without giving a correct remove key"})
    else
      page.delete
    end
  end

  def PageController.decorateCode(code)
    keywords = ["class", "continue", "for", "new", "switch", "assert", "default", "goto",\
      "package", "synchronized", "boolean", "do", "if", "private", "this", "break", "double",\
      "implements", "protected", "throw", "byte", "else", "import", "public", "throws", "case",\
      "enum", "instanceof", "return", "transient", "catch", "extends", "int", "short", "try",\
      "char", "final", "interface", "static", "void", "abstract", "finally", "long", "strictfp",\
      "volatile", "const", "float", "native", "super", "while", "var", "true", "false"]
    new_code = Array.new
    in_comments_block = false
    code.each_line {|line|
      line = line.chomp.gsub("<", "&lt;").gsub(">", "&gt;")
      if (line =~ /\/\*/) != nil
        in_comments_block = true
      end
      if in_comments_block
        line = line.sub(/(.*)$/, '<span class="comments">\1</span>')
      else
        line = line.sub(/(".*")/, '<span class="string">\1</span>')
        line = line.sub(/('.*')/, '<span class="string">\1</span>')
        for keyword in keywords
          line = line.gsub(/( |^)#{keyword}( |$|;)/, "<span class=\"keyword\">\\1#{keyword}\\2</span>")
        end
        line = line.sub(/(\/\/.*)$/, '<span class="comments">\1</span>')
        line = line.sub(/(#.*)$/, '<span class="comments">\1</span>')
      end
      if (line =~ /\*\//) != nil
        in_comments_block = false
      end
      new_code << line
    }
    return new_code.join("\n")
  end

  def PageController.top(params, sinatraApp)
    limit = params[:top]
    if limit == nil
      limit = 20
    end
    pages = Page.order("view_count DESC").limit(limit)
    return sinatraApp.erb(:top, :locals => {:pages => pages, :top_count => limit})
  end
end