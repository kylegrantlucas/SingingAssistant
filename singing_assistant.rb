require 'bundler'
Bundler.require(:middleware, :default)
require 'sinatra/namespace'
require 'yaml'

class SingingAssistant < Sinatra::Base
  use Rack::PostBodyContentTypeParser
  register Sinatra::Namespace
  
  configure do
    set :protection, :except => [:json_csrf]
    set :config, RecursiveOpenStruct.new(YAML.load_file('./config/config.yml'))
    enable :inline_templates
  end

  before do
    @echo_request = AlexaObjects::EchoRequest.new(request.params) if request.request_method == "POST"
  end

  proxy_namespace = settings.config.proxy_path if settings.config.proxy_path 
  namespace proxy_namespace do
    register Sinatra::Couchpotato
    register Sinatra::Hue
    # register Sinatra::Halo
    #register Sinatra::Transmission
    # register Sinatra::Sickbeard
  end
end
