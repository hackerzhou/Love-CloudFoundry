require 'rubygems'
require 'sinatra'
require 'active_record'
require 'logger'
require 'rack'
require 'json'
require 'digest/sha1'
require 'cfruntime/properties'
require './model/page'
require './model/admin'
require './controller/page_controller'
require './controller/rest_controller'

set :environment, :production
enable :sessions

helpers do
  include Rack::Utils
end

configure do
  database_settings = {}
  database_settings[:host] = '127.0.0.1'
  database_settings[:port] = 5432
  database_settings[:username] = 'hackerzhou'
  database_settings[:password] = 'password'
  database_settings[:database] = 'iloveu'
  if CFRuntime::CloudApp.running_in_cloud?
    database_settings = CFRuntime::CloudApp.service_props('iloveu')
  else
    set :port, 8080
  end
  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :host     => database_settings[:host],
    :database => database_settings[:database],
    :username => database_settings[:username],
    :password => database_settings[:password],
    :pool => 10
  )
  migrations = "#{settings.root}/db/migrate"
  if File.directory?("#{settings.root}/db/migrate")
    ActiveRecord::Migrator.migrate(migrations)
  end
end

after do
  ActiveRecord::Base.clear_active_connections!
end

get '/page/:url_mapping' do
  PageController.render(params, self)
end

get '/create' do
  erb :create
end

post '/create' do
  PageController.create(params, self)
end

get '/' do
  PageController.renderIndex(self)
end

post '/page/:url_mapping/delete' do
  PageController.delete(params, self)
end

get '/preview.html' do
  PageController.preview(request, self)
end

get '/top' do
  PageController.top(params, self)
end

get '/ajax_check/urlsuffix.json' do
  PageController.urlSuffixAjax(params, self)
end

post '/mgmt_rest_service/:method' do
  RestController.handle(params, self)
end

not_found do
  redirect '/'
end