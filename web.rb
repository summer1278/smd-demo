require 'rubygems'
require 'sinatra'

input_directory = './data/'

# Index Page
get '/' do
  @page_title = 'Radio List'
  @input_directory = input_directory
  erb(:index) 
end

# Combined Results page
get '/item/:uuid' do
  @uuid = params['uuid']
  @input_directory = input_directory
  erb(:result)
end

# Single Results page
get '/item/:uuid/:type' do
  @uuid = params['uuid']
  @type = params['type']
  @input_directory = input_directory
  erb(:single_result)
end

# Serve data
get '/data/*' do
  @data_directory = 'data'
  send_file @data_directory + '/' + params[:splat].join('/')
end
