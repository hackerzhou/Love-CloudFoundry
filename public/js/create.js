var urlMappingAvailable = false;
$(function() {
  var createFormWrapper = $("#create_form_wrapper")
  createFormWrapper.css("margin-left", Math.max(($(window).width() - createFormWrapper.width()) / 2, 10));
  $("#start_time").datetimepicker({
    timeFormat: "hh:mm:ss",
    ampm: false,
    dateFormat: "yy-mm-dd",
    showMonthAfterYear: true,
      changeMonth: true,
      changeYear: true,
      hourGrid: 6,
      minuteGrid: 15,
      secondGrid: 15,
      showSecond: true
  });
  $("#interval_slider").slider({
      min: 0,
      max: 9,
      value: 5,
      step: 1,
      slide: function(event, ui) {
        $("#interval_display").html(ui.value + " second(s)");
        $("#interval")[0].value = ui.value * 1000;
      }
  });
  $("#words_interval_slider").slider({
      min: 0,
      max: 9,
      value: 5,
      step: 1,
      slide: function(event, ui) {
        $("#words_interval_display").html(ui.value + " second(s)");
        $("#words_interval")[0].value = ui.value * 1000;
      }
  });
  $("#signature_interval_slider").slider({
      min: 0,
      max: 9,
      value: 5,
      step: 1,
      slide: function(event, ui) {
        $("#signature_interval_display").html(ui.value + " second(s)");
        $("#signature_interval")[0].value = ui.value * 1000;
      }
  });
  $("#typewriter_slider").slider({
      min: 2,
      max: 4,
      value: 3,
      step: 1,
      slide: function(event, ui) {
        switch(ui.value) {
          case 2:
            $("#typewriter_display").html("Slow");
            break;
          case 4:
            $("#typewriter_display").html("Fast");
            break;
          default:
            $("#typewriter_display").html("Medium");
            ui.value = 3;
            break;
        }
        $("#typewriter_speed")[0].value = (6 - ui.value) * 25;
      }
  });
  $("#loveheart_slider").slider({
      min: 1,
      max: 3,
      value: 2,
      step: 1,
      slide: function(event, ui) {
        switch(ui.value) {
          case 1:
            $("#loveheart_display").html("Slow");
            break;
          case 3:
            $("#loveheart_display").html("Fast");
            break;
          default:
            $("#loveheart_display").html("Medium");
            ui.value = 2;
            break;
        }
        $("#loveheart_speed")[0].value = (4 - ui.value) * 25;
      }
  });
});

jQuery.cookie = function(name, value, options) {
  if (typeof value != 'undefined') {
    options = options || {};
    if (value === null) {
      value = '';
      options = $.extend({}, options);
      options.expires = -1;
    }
    var expires = '';
    if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
      var date;
      if (typeof options.expires == 'number') {
        date = new Date();
        date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
      } else {
        date = options.expires;
      }
      expires = '; expires=' + date.toUTCString();
    }
    var path = options.path ? '; path=' + (options.path) : '';
    var domain = options.domain ? '; domain=' + (options.domain) : '';
    var secure = options.secure ? '; secure' : '';
    document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else {
      var cookieValue = null;
      if (document.cookie && document.cookie != '') {
      var cookies = document.cookie.split(';');
      for (var i = 0; i < cookies.length; i++) {
        var cookie = jQuery.trim(cookies[i]);
        if (cookie.substring(0, name.length + 1) == (name + '=')) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }
};

function previewPage() {
  if(!checkForm()) {
    return;
  }
  setCookies();
  $.colorbox({
    iframe:true,
    width:"100%",
    height:"100%",
    href:"/preview.html?ran=" + Math.random()
  });
}

function setCookies() {
  var date = new Date();
  date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));
  $.cookie("url_suffix", $("#url_suffix")[0].value, { path: '/', expires: date });
  $.cookie("page_name", $("#page_name")[0].value, { path: '/', expires: date });
  $.cookie("your_name", $("#your_name")[0].value, { path: '/', expires: date });
  $.cookie("lover_name", $("#lover_name")[0].value, { path: '/', expires: date });
  $.cookie("your_words", $("#your_words")[0].value, { path: '/', expires: date });
  $.cookie("start_time", $("#start_time")[0].value, { path: '/', expires: date });
  $.cookie("interval", $("#interval")[0].value, { path: '/', expires: date });
  $.cookie("loveheart_speed", $("#loveheart_speed")[0].value, { path: '/', expires: date });
  $.cookie("typewriter_speed", $("#typewriter_speed")[0].value, { path: '/', expires: date });
  $.cookie("words_interval", $("#words_interval")[0].value, { path: '/', expires: date });
  $.cookie("signature_interval", $("#signature_interval")[0].value, { path: '/', expires: date });
}

function checkForm() {
  var ok = checkUrlSuffixAvailable($("#url_suffix")[0], "#page_url");
  ok = checkPageName($("#page_name")[0]) && ok;
  ok = checkYourName($("#your_name")[0]) && ok;
  ok = checkLoverName($("#lover_name")[0]) && ok;
  ok = checkDeleteKey($("#delete_key")[0]) && ok;
  ok = checkYourWords($("#your_words")[0]) && ok;
  ok = checkStartTime($("#start_time")[0]) && ok;
  return ok;
}

function checkUrlSuffix(inputObj, pageUrlId) {
  return checkRegExp(inputObj, /^\w{1,32}$/, "Only allow a-z, A-Z, 0-9 or _, no longer than 32 characters.",
            function (){
              $(pageUrlId).html("Page URL: http://iloveu.cloudfoundry.com/page/" + inputObj.value);
            },
            function (){
              $(pageUrlId).html("");
            });
}

function checkUrlSuffixAvailable(inputObj, pageUrlId) {
  var check = checkUrlSuffix(inputObj, pageUrlId);
  var errMsg = $("#" + inputObj.id + "_err");
  if (check) {
    $.ajax({
      url: '/ajax_check/urlsuffix.json?url_mapping=' + inputObj.value + '&ran=' + Math.random(),
      type: 'GET',
      dataType: 'json',
      timeout: 1000,
      beforeSend: function() {
        urlMappingAvailable = false;
        errMsg.html("");
      },
      success: function(data, textStatus, xhr) {
        urlMappingAvailable = (data == 0);
        if(!urlMappingAvailable) {
          errMsg.html("URL suffix used by others!");
        }
      }
    });
  }
  return check;
}

function checkPageName(inputObj) {
  return checkRegExp(inputObj, /^.{1,32}$/, "Should not longer than 32 characters.");
}

function checkYourName(inputObj) {
  return checkRegExp(inputObj, /^.{1,32}$/, "Should not longer than 32 characters.");
}

function checkLoverName(inputObj) {
  return checkRegExp(inputObj, /^.{1,32}$/, "Should not longer than 32 characters.");
}

function checkDeleteKey(inputObj) {
  return checkRegExp(inputObj, /^.{6,16}$/, "6-16 characters long.");
}

function checkYourWords(inputObj) {
  return checkRegExp(inputObj, /^[\s\S]{1,4096}$/, "Should not longer than 4096 characters.");
}

function checkStartTime(inputObj) {
  return checkRegExp(inputObj, /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/, "Incorrect datetime format.");
}

function checkRegExp(obj, regExp, failedMsg, ok_callback, failed_callback) {
  var ok = false;
  var text = obj.value;
  var msgId = "#" + obj.id + "_err";
  if (text == null || text.length == 0) {
    $(msgId).html("Required field cannot be empty!");
  } else if (!regExp.test(text)) {
    $(msgId).html(failedMsg);
  } else {
    $(msgId).html("");
    ok = true;
  }
  if (ok && ok_callback) {
    ok_callback();
  } else if (!ok && failed_callback) {
    failed_callback();
  }
  return ok;
}
