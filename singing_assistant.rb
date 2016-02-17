require 'bundler'
Bundler.require(:middleware, :default)
require './lib/helpers/application.rb'
require 'json'
require 'yaml'

class SingingAssistant < Sinatra::Base
  alexa_plugin_gems.each { |gem_name| self.send(:register, Module.const_get(gem_name.camelize)) }

  configure do
    set :protection, :except => [:json_csrf]
    set :config, RecursiveOpenStruct.new(YAML.load_file('./config/config.yml'))
    enable :inline_templates
  end

  before do
    @echo_request = AlexaObjects::EchoRequest.new(JSON.parse(request.body.read)) if request.request_method == "POST"
  end

  post (settings.config.proxy_path || '/') do
    if @echo_request.launch_request?
        AlexaObjects::Response.new(end_session: false, spoken_response: "Your Singing Assistant is ready.").to_json
    elsif @echo_request.session_ended_request?
      AlexaObjects::Response.new.to_json
    else
      self.send(@echo_request.intent_name.underscore.to_sym)
    end
  end
end