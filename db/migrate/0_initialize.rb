class Initialize < ActiveRecord::Migration
  def up
    create_table :pages, :id => false, :force => true do |t|
      t.string   :url_mapping, :null => false, :limit => 32, :unique => true
      t.string   :display_name, :null => false, :limit => 32
      t.text     :message, :null => false
      t.datetime :start_time, :null => false
      t.string   :lover_name, :null => false, :limit => 32
      t.string   :your_name, :null => false, :limit => 32
      t.string   :page_key, :null => false, :limit => 64
      t.integer  :view_count, :default => 1
      t.integer  :interval, :default => 5000
      t.integer  :typewriter_speed, :default => 75
      t.integer  :loveheart_speed, :default => 50
      t.integer  :signature_interval, :default => 3000
      t.integer  :words_interval, :default => 5000
      t.datetime :created_at
    end
    ActiveRecord::Base.connection.execute("ALTER TABLE pages ADD PRIMARY KEY (url_mapping)")
    html_string = <<HTML_STRING
/**
 * We are both Fudan SSers and programmers,
 * so I write some code to celebrate our 1st anniversary.
 */
Boy i = new Boy("hackerzhou");
Girl u = new Girl("MaryNee");
// Nov 2, 2010, I told you I love you. 
i.love(u);
// Luckily, you accepted and became my girlfriend eversince.
u.accepted();
// Since then, I miss u every day.
i.miss(u);
// And take care of u and our love.
i.takeCareOf(u);
// You say that you won't be so easy to marry me.
// So I keep waiting and I have confidence that you will.
boolean isHesitate = true;
while (isHesitate) {
  i.waitFor(u);
  // I think it is an important decision
  // and you should think it over.
  isHesitate = u.thinkOver();
}
// After a romantic wedding, we will live happily ever after.
i.marry(u);
i.liveHappilyWith(u);
HTML_STRING

    Page.create :url_mapping => "hackerzhou",
      :display_name => "Our Love Story",
      :start_time => "2010-11-02 20:00:00",
      :lover_name => "MaryNee",
      :your_name => "hackerzhou",
      :page_key => "#DEFAULT_PAGE_PASSWORD#",
      :message => html_string

    create_table :admins, :force => true do |t|
      t.string   :username, :limit => 32, :null => false, :unique => true
      t.string   :password, :limit => 64, :null => false
      t.datetime :last_login
      t.datetime :created_at
    end
  add_index(:admins, [:username, :password])

    Admin.create :username => "#ADMIN_USERNAME#",
      :password => "#ADMIN_PASSWORD#"
  end

  def down
    drop_table :pages
    drop_table :admins
  end
end