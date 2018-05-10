require 'sinatra'
require 'data_mapper'
require 'combine_pdf'

enable :sessions

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/fpro.db")
end

class User
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
User.auto_upgrade!

@@curracc = nil
this = false

get '/' do
  this = true
  @@sig = false
	erb :main
end
get '/sign_in' do
  this = true
	erb :signin
end
get '/sign_up' do
  this = true
	erb :signup
end

post '/upload' do
  files = params["files"]
  pdfFile = CombinePDF.new

  files.each do |f|
    realfile = f["tempfile"].read
    temp = CombinePDF.parse(realfile)
    pdfFile << temp
  end
  pdfFile.save "final.pdf"

  status 200
  headers 'content-type' => "application/pdf"
  body pdfFile.to_pdf
end

get '/infochange' do
  if this == false
    redirect '/'
  end
  if @@sig == false
    redirect '/sign_in'
  end
  if @@curracc.logged == true
    erb :infochange
  end
end
post '/changed' do
  if this == false
    redirect '/'
  end
  if @@sig == false
    redirect '/sign_in'
  end
  if @@curracc.logged == true
    if (params["email"] && params["password"] && params["firstname"] && params["lastname"])
      emai = params["email"]
      pass = params["password"]
      fir = params["firstname"]
      las = params["lastname"]
      if emai.length != 0 && pass.length != 0
        @@curracc.email = emai
        @@curracc.password = pass
        @@curracc.fname = fir
        @@curracc.lname = las
        @@curracc.save
      end
      redirect '/accinfo'
    end
  end
end
get '/accinfo' do
  if this == false
    redirect '/'
  end
  if @@sig == false
    redirect '/sign_in'
  end
  if @@curracc.logged == true
    erb :myacc
  end
end
get '/account' do
  if this == false
    redirect '/'
  end

  if @@sig == false 
    redirect '/sign_in'
  end

  if @@curracc.logged == true
    erb :main2
  end

end
get '/loggt' do
  #false
  if this == false
    redirect '/'
  end
  #both false
  @@sig = true
  @@curracc.logged = true
  @@curracc = nil
  redirect '/'
end


post '/created' do
  if User.first(email: params["email"])
      redirect 'sign_up'
  end
  if (params["email"] && params["password"] && params["firstname"] && params["lastname"])
    emai = params["email"]
    pass = params["password"]
    fir = params["firstname"]
    las = params["lastname"]
    if emai.length != 0 && pass.length != 0
      p = User.new
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
  u = User.first(email: params["email"])
  if u && u.password == params["password"]
    @@curracc = u
    @@curracc.logged = true
    @@sig = true
    redirect '/account'
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
get '/noauth' do
  if !session[:times].nil?
     session[:times] = session[:times] + 1
  else 
    session[:times] = 0
    erb :main2
  end

  if (session[:times] < 3 &&  @@sig == false)
    erb :main2
  else 
     redirect '/sign_in'
  end
end

get '/about_us' do
  erb :aboutus
end