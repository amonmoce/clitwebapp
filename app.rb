require 'sinatra/base'
require 'haml'
require 'httparty'
require 'asposecloud'
require_relative 'model/registered'

class ClitApp < Sinatra::Base
  configure do
    AWS.config(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:ENV['AWS_REGION']
    )
  end

  SERVER_URI = 'http://localhost:9292'

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
    #response = HTTParty.post('https://view-upload.herokuapp.com//url-upload', :body => { :document-url => "#{SERVER_URI}/uploaded_files/#{@filename}"})
    #File.delete("./public/#{@filename}")
    redirect "/convert/#{@filename}"
    haml :register
  end

  get '/uploaded_files/:filename' do
    send_file File.join('public', params[:filename])
  end

  get '/convert/:filename' do
    app_sid = ENV['APP_SID']
    app_key = ENV['APP_KEY']
    Aspose::Cloud::Common::AsposeApp.new(app_sid, app_key)
    Aspose::Cloud::Common::Product.set_base_product_uri('http://api.aspose.com/v1.1')
    converter_object = Aspose::Cloud::Pdf::Converter.new("#{SERVER_URI}/uploaded_files/#{params[:filename]}")
    puts converter_object.convert('', '', 'html')

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
