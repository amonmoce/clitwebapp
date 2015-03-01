require 'sinatra/base'
require 'haml'
require 'httparty'
require 'json'
require 'pdf-reader'
require_relative 'model/registered'
require_relative 'model/pdfdata'

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
    @@classid = registration.id
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
    pdf_file = []
    reader = PDF::Reader.new("public/#{params[:filename]}")
    reader.pages.each do |page|
      pdf_file << page.text
    end
    pdf_text = pdf_file.join(" NEXTPAGE ")
    data2send = {
      pdfdata: pdf_text,
      classid: @@classid
    }
    pdfdata = Pdfdata.new(data2send)
    @converted = 0
    if pdfdata.save
      @converted = 1
    end
    @filename = params[:filename]
    haml :register
  end

  get '/start' do
    haml :start
  end

  get '/list' do
    @classcode = []
    @classname = []
    dynamo_db = AWS::DynamoDB.new
    dynamo_db.tables.each do |x|
      if x.name == 'Registered'
        x.load_schema.items.each do |item|
          @classcode << item.attributes['classcode']
          @classname << item.attributes['classname']
        end
      end
    end
    haml :list
  end

  get '/translate' do
    haml :translate
  end

  post '/translation' do
    @source = params[:source]
    @target = ''
    File.open("translation/input", 'w') {|f| f.write(@source) }
    `python translation/decode > translation/output`
    File.open("translation/output", "r").each_line do |line|
      @target << line
    end
    haml :translate
  end

  get '/translated' do
    haml :translated
  end

  not_found do
    status 404
    'The page you are looking for does not exist'
  end

end
