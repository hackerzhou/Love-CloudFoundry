require 'json'

class Page < ActiveRecord::Base
  self.primary_key = "url_mapping"
  attr_accessible :url_mapping,\
    :display_name,\
    :message,\
    :lover_name,\
    :your_name,\
    :page_key,\
    :start_time,\
    :created_at,\
    :view_count,\
    :interval,\
    :typewriter_speed,\
    :loveheart_speed,\
    :signature_interval,\
    :words_interval

  def self.to_json
    JSON.dump({
      "url_mapping" => self.url_mapping,
      "display_name" => self.response_msg,
      "lover_name" => self.lover_name,
      "your_name" => self.your_name,
      "start_time" => self.start_time,
      "created_at" => self.created_at,
      "view_count" => self.view_count,
      "interval" => self.interval,
      "typewriter_speed" => self.typewriter_speed,
      "loveheart_speed" => self.loveheart_speed,
      "signature_interval" => self.signature_interval,
      "words_interval" => self.words_interval,
      "message" => self.message
    })
  end
end