def alexa_plugin_gems
  Bundler.load.specs.map{|x|x.name[6..-1] if x.name[0...6] == "alexa_" && x.name[6..-1] != "objects"}.compact
end