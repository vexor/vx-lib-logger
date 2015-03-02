require "bundler/gem_tasks"

require 'rake/testtask'

task :spec do
  $LOAD_PATH.unshift(File.expand_path("../spec", __FILE__))
  Dir.glob('./spec/lib/*_spec.rb').each { |file| require file}
end

task default: :spec
