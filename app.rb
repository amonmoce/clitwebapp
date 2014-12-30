require 'sinatra/base'
require 'haml'

class ClitApp < Sinatra::Base

  get '/' do
      haml :home
  end

end
