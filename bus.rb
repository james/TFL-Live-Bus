require 'sinatra'
require 'net/http'
require 'json'
require 'erb'
set :views, File.dirname(__FILE__) + '/templates'
set :public, File.dirname(__FILE__) + '/static'

STOPS = JSON.parse(File.read("./bus_stops.json"))["markers"]

get '/' do
  if params[:search] && params[:search] != ""
    @search_results = STOPS.select {|x| x["name"] =~ /#{params[:search]}/i}
  end
  erb :index
end

get '/stop/:stop_id' do |stop_id|
  @stop = STOPS.select {|x| x["id"] =~ /#{stop_id}/i}.first
  get_stop_json(stop_id)
  erb :stop
end

get '/stop/:stop_id/partial' do |stop_id|
  get_stop_json(stop_id)
  erb :indicator_table
end

get '/stop/:stop_id/curl' do |stop_id|
  get_stop_json(stop_id)
  @json["arrivals"].collect{|x| "#{x["routeId"]} | #{x["estimatedWait"]}\n"}
end

get '/stop/:stop_id/jsonp' do |stop_id|
  get_stop_json(stop_id)
  "bus_json(#{@json})"
end


def get_stop_json(stop_id)
  response = Net::HTTP.get(URI.parse("http://countdown.tfl.gov.uk/stopBoard/#{stop_id}/"))
  @json = JSON.parse(response)  
end
