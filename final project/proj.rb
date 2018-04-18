require 'sinatra'
require 'data_mapper'
#links to info: https://github.com/guilhermesad/rspotify
#https://github.com/icoretech/spotify-client

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/fpro.db")
end

class Post
    include DataMapper::Resource
    property :id, Serial
    property :fname, String
    property :lname, String
    property :email, String
    property :password, String
    property :created_at, DateTime
    property :paidpro, Boolean
    property :paid, Boolean
    property :logged, Boolean
    property :freemerge, Integer
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!

get '/' do
  @@sig = false
	erb :main
end
get '/sign_in' do
	erb :signin
end
get '/sign_up' do
	erb :signup
end
get '/account' do
  if @@sig == false
    redirect '/sign_in'
  end
  if @@curracc.logged == true
    erb :main2
  end
end
get '/loggt' do
  @@sig = false
  @@curracc.logged = false
  redirect '/'
end
post '/created' do
  accts = Post.all
  accts.each do |acct|
    if acct.email == params["email"]
      redirect '/sign_up'
    end
  end
  if (params["email"] && params["password"] && params["firstname"] && params["lastname"])
    emai = params["email"]
    pass = params["password"]
    fir = params["firstname"]
    las = params["lastname"]
    if emai.length != 0 && pass.length != 0
      p = Post.new
      p.email = emai
      p.password = pass
      p.fname = fir
      p.lname = las
      p.paidpro = false
      p.paid = false
      p.logged = false
      p.freemerge = 3
      p.save
    end
  end
  redirect '/sign_in'
end
post '/signed' do
  accts = Post.all
  accts.each do |acct|
    if acct.email == params["email"]
      if acct.password == params["password"]
        @@curracc = acct
        @@curracc.logged = true
        @@sig = true
        redirect '/account'
      end
    end
  end
  redirect '/sign_in'
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
