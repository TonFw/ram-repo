require 'bundler/gem_tasks'
Dir.glob('lib/tasks/*.rake').each {|r| import r}

def specs(dir)
  FileList["spec/#{dir}/*_spec.rb"].shuffle.join(' ')
end

desc 'Runs all the specs'
task :specs do
  sh "bundle exec bacon #{specs('**')}"
end

task :default => :specs