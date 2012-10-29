class Admin < ActiveRecord::Base
  attr_accessible :username,\
    :password,\
    :last_login,\
    :created_at

  def self.to_json
    JSON.dump({
      "username" => self.username,
      "last_login" => self.last_login,
      "created_at" => self.created_at
    })
  end
end