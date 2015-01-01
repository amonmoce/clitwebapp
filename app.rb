require 'sinatra/base'
require 'haml'
require_relative 'model/registered'

class ClitApp < Sinatra::Base
  configure do
    AWS.config(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:ENV['AWS_REGION']
    )
  end

  get '/' do
      haml :home
  end

  get '/register' do
    haml :register
  end

  post '/register' do
    @classname = params[:classname]
    registration_data = {
        classname: @classname,
        classcode: params[:classcode],
        teachercode: params[:teachercode]
    }
    registration = Registered.new(registration_data)
    @okay = 0
    if registration.save
      @okay = 1
    end
    haml :register
  end

  post '/upload' do
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
    File.open("./public/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    @upload = 1
    haml :register
  end

  get '/uploaded_files/:filename' do
    send_file File.join('public', params[:filename])
  end

  get '/start' do
    haml :start
  end

  get '/list' do
    haml :list
  end

  get '/translated' do
    haml :translated
  end

  not_found do
    status 404
    'The page you are looking for does not exist'
  end

end
