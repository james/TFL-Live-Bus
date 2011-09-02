require 'sinatra'
require 'net/http'
require 'json'
require 'erb'
set :views, File.dirname(__FILE__) + '/templates'
set :public, File.dirname(__FILE__) + '/static'

get '/stop/:stop_id' do |stop_id|
  get_stop_json(stop_id)
  erb :stop
end

get '/stop/:stop_id/partial' do |stop_id|
  get_stop_json(stop_id)
  erb :indicator_table
end

def get_stop_json(stop_id)
  response = Net::HTTP.get(URI.parse("http://countdown.tfl.gov.uk/stopBoard/#{stop_id}/"))
  @json = JSON.parse(response)  
end
