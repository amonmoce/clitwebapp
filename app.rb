require 'sinatra/base'
require 'sinatra/flash'
require 'haml'

class ClitApp < Sinatra::Base
  register Sinatra::Flash
  
  get '/' do
      haml :home
  end

  get '/register' do
    haml :register
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

end
