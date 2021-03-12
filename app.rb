require 'slim'
require 'sinatra'
require 'sqlite3'
require 'bcrypt'
require 'byebug'

enable :sessions

get('/') do
    slim(:register)
  end

get('/showlogin') do 
    slim(:login)
end 

get('/annons/new') do 
    slim(:annons)
end 

post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/databas.db')
    db.results_as_hash = true
    result = db.execute("SELECT *FROM user WHERE username = ?",username).first
    pwdigest = result["pwdigest"]
    id = result["id"]
  
    if BCrypt::Password.new(pwdigest) == password
      session[:id] = id
      redirect('/annons/new')
    else
      "Fel lösenord!"
    end
  end
  
post('/users/new') do 
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
  
    if (password == password_confirm)
      password_digest = BCrypt::Password.create(password)
      db = SQLite3::Database.new('db/databas.db')
      db.execute("INSERT INTO user (username,pwdigest) VALUES (?,?)",username,password_digest)
      redirect('/')
    else
      "Lösenorden matchade inte!"
    end
  end

post('/annons/new') do
    rubrik = params[:rubriken]
    bio = params[:bio]
    pris = params[:pris]

    db = SQLite3::Database.new('db/databas.db')
    db.execute("INSERT INTO annons (rubrik,bio,pris) VALUES (?,?,?)",rubrik,bio,pris)
    redirect('/')
end