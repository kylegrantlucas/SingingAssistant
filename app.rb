require 'bundler'
Bundler.require

class SingingAssistant < Sinatra::Base
  set :protection, :except => [:json_csrf]
  enable :inline_templates

  register Sinatra::Couchpotato
  register Sinatra::Hue
  register Sinatra::Halo
  register Sinatra::Transmission
  register Sinatra::Sickbeard
end
