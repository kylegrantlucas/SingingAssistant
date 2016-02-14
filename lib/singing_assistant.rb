require 'bundler'
Bundler.require(:middleware, :required)
require 'alexa_objects'
require 'sinatra/base'
require 'pry'
require 'rack'
require 'rack/config'
require 'yaml'
require 'recursive-open-struct'

class SingingAssistant < Sinatra::Base
  use Rack::PostBodyContentTypeParser
  
  configure do
    set :protection, :except => [:json_csrf]
    set :config, RecursiveOpenStruct.new(YAML.load_file('./config/config.yml'))
    enable :inline_templates
  end

  before do
    if request.request_method == "POST"
      @echo_request = AlexaObjects::EchoRequest.new(request.params) 
      @application_id = @echo_request.application_id
    end
  end

  register Sinatra::Couchpotato
  register Sinatra::Hue
  # register Sinatra::Halo
  register Sinatra::Transmission
  # register Sinatra::Sickbeard
end
