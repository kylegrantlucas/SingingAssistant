namespace :skill_config do
  desc 'Generates sampl_utterance.txt witht the utterances from the selected gems'
  task generate_sample_utterances: :environment do
    gems = Bundler.require(:middleware)
    alexa_gems = gems.map{|x|x.name}.select{|x|x[0...6]=="alexa_"}-['alexa_objects']
    alexa_gems.each do {|gem_name| require "#{gem_name}/sample_utterances"}
    File.open('sample_utterances.txt', 'w') do |f|
      alexa_gems.each do |gem_name|
        f << Module.const_get("Sinatra::#{gem_name[6..-1].capitalize}").sample_utterances
      end
    end
  end
end