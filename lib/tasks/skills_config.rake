require 'active_support'
require 'active_support/core_ext/string'
require "rake"

namespace :skills_config do
  desc 'Generates sample_utterance.txt witht the utterances from the selected gems'
  task :generate_sample_utterances do
    gems = Bundler.require(:middleware)
    Dir.mkdir 'skills_setup' rescue nil
    alexa_gems = gems.map{|x|x.name}.select{|x|x[0...6]=="alexa_"}-['alexa_objects']
    alexa_gems.each {|gem_name| require "#{gem_name}/sample_utterances"}
    File.open('./skills_setup/sample_utterances.txt', 'w') do |f|
      alexa_gems.each do |gem_name|
        f << Module.const_get("#{gem_name[6..-1].camelize}").sample_utterances
        f << "\n\n"
      end
    end
  end

  desc 'Generates custom_slots.txt witht the utterances from the selected gems'
  task :generate_custom_slots do
    gems = Bundler.require(:middleware)
    Dir.mkdir 'skills_setup' rescue nil
    alexa_gems = gems.map{|x|x.name}.select{|x|x[0...6]=="alexa_"}-['alexa_objects']
    alexa_gems.each {|gem_name| require "#{gem_name}/custom_slots"}
    File.open('./skills_setup/custom_slots.txt', 'w') do |f|
      alexa_gems.each do |gem_name|
        f << Module.const_get("#{gem_name[6..-1].capitalize}").custom_slots
        f << "\n\n"
      end
    end
  end

  desc 'Generates intents_schema.txt witht the utterances from the selected gems'
  task :generate_intent_schema do
     gems = Bundler.require(:middleware)
     Dir.mkdir 'skills_setup' rescue nil
    alexa_gems = gems.map{|x|x.name}.select{|x|x[0...6]=="alexa_"}-['alexa_objects']
    alexa_gems.each {|gem_name| require "#{gem_name}/intent_schema"}
    File.open('./skills_setup/intent_schema.json', 'w') do |f|
      schemas = []
      alexa_gems.each do |gem_name|
        schemas << JSON.parse(Module.const_get("#{gem_name[6..-1].camelize}").intent_schema)["intents"]
      end

      f << JSON.pretty_generate({"intents" => schemas.flatten(1)})
    end
  end

  desc 'Generates intents_schema.txt witht the utterances from the selected gems'
  task :generate_lambda_router do
    Dir.mkdir 'skills_setup' rescue nil
    File.open('./skills_setup/lambda_router.js', 'w') do |f|
      settings = RecursiveOpenStruct.new(YAML.load_file('./config/config.yml'))

      file_string = <<-FIN
var http = require('http');
var URLParser = require('url');
 
exports.handler = function (json, context) {
    try {
        var url = "http://#{settings.url}#{settings.proxy_path}";
        if (!url) { context.fail("No url found for application id"); }
        var parts = URLParser.parse(url);
        
        var post_data = JSON.stringify(json);
        
        // An object of options to indicate where to post to
        var post_options = {
            host: parts.hostname,
            auth: parts.auth,
            port: (parts.port || 80),
            path: parts.path,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': post_data.length
            }
        };
        // Initiate the request to the HTTP endpoint
        var req = http.request(post_options,function(res) {
            var body = "";
            // Data may be chunked
            res.on('data', function(chunk) {
                body += chunk;
            });
            res.on('end', function() {
                // When data is done, finish the request
                context.succeed(JSON.parse(body));
            });
        });
        req.on('error', function(e) {
            context.fail('problem with request: ' + e.message);
        });
        // Send the JSON data
        req.write(post_data);
        req.end();        
    } catch (e) {
        context.fail("Exception: " + e);
    }
};
                FIN
       f << file_string
    end
  end
end