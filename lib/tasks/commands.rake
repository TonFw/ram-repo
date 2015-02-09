require 'colorize'

desc "RAM Pods PlugIn commands to easy debug"
namespace :ram do
  # Vars to help while executing tasks
  @repo_name = 'ram-repo'
  @repo_url = 'http://localhost'

  desc "RAM add: useful to create a repo on ~/.cocoapods/repos/NAME"
  task :add do
    puts 'RAM:Add running'.light_yellow
    # Call executed here!
    puts("Command executed:\npods pod ram add #{@repo_name} #{@repo_url}".green)
  end

  desc "RAM update: useful to update the dependencies version on your project"
  task :update do
    puts 'RAM:Update running'.light_yellow
    # Call executed here!
    puts("Command executed:\npods pod ram add #{@repo_name} #{@repo_url}".green)
  end

  desc "RAM lint: useful to check if the dependencies folder structure are OK"
  task :lint do
    puts 'RAM:Lint running'.light_yellow
    # Call executed here!
    puts("Command executed:\npods pod ram add #{@repo_name} #{@repo_url}".green)
  end
end