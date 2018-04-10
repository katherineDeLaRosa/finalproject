require 'sinatra'
require 'spotify-client'
require 'rspotify'
#links to info: https://github.com/guilhermesad/rspotify
#https://github.com/icoretech/spotify-client


get '/' do
	erb :main
end
get '/group' do 
	"group code:"
end
get '/payment' do
	"this is where we do pay things & checking about spotify here (if we get that far)"
end
post '/charge' do
	"this is checking if vaild stripe would go here"
end
