namespace :skill_config do
  desc 'Generates sample_utterance.txt witht the utterances from the selected gems'
  task :generate_sample_utterances do
    gems = Bundler.require(:middleware)
    alexa_gems = gems.map{|x|x.name}.select{|x|x[0...6]=="alexa_"}-['alexa_objects']
    alexa_gems.each {|gem_name| require "#{gem_name}/sample_utterances"}
    File.open('sample_utterances.txt', 'w') do |f|
      alexa_gems.each do |gem_name|
        f << Module.const_get("Sinatra::#{gem_name[6..-1].capitalize}").sample_utterances
        f << "\n\n"
      end
    end
  end

  desc 'Generates custom_slots.txt witht the utterances from the selected gems'
  task :generate_custom_slots do
    gems = Bundler.require(:middleware)
    alexa_gems = gems.map{|x|x.name}.select{|x|x[0...6]=="alexa_"}-['alexa_objects']
    alexa_gems.each {|gem_name| require "#{gem_name}/custom_slots"}
    File.open('custom_slots.txt', 'w') do |f|
      alexa_gems.each do |gem_name|
        f << Module.const_get("Sinatra::#{gem_name[6..-1].capitalize}").custom_slots
        f << "\n\n"
      end
    end
  end
end