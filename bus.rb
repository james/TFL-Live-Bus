require 'sinatra'
require 'net/http'
require 'json'
require 'erb'
set :views, File.dirname(__FILE__) + '/templates'

get '/stop/:stop_id' do |stop_id|
  response = Net::HTTP.get(URI.parse("http://countdown.tfl.gov.uk/stopBoard/#{stop_id}/"))
  @json = JSON.parse(response)
  erb :stop
end
