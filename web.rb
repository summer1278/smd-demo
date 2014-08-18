require 'rubygems'
require 'sinatra'

# Index Page
get '/' do
  @page_title = 'Radio lIST'
  erb(:index) 
end

# Results page
get '/item/:uuid' do
  @uuid = params['uuid']
  erb(:result)
end

# Serve data
get '/data/*' do
  @data_directory = 'data'
  send_file @data_directory + '/' + params[:splat].join('/')
end
