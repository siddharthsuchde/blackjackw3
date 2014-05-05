require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true


get '/home' do
	"Welcome Home! Hi I'm sidd."
end

get '/inline' do
	"Hi, directly from this action"
end
 
#rendering a template
#will look for a template under views
#therefore create a new file .erb
#can write HTML in .erb file.
 
get '/template' do
	"hello world"
	#erb :mytemplate
end
