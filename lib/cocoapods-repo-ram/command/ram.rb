# This is an example of a cocoapods plugin adding a top-level subcommand
# to the 'pod' command.
#
# You can also create subcommands of existing or new commands. Say you
# wanted to add a subcommand to `list` to show newly deprecated pods,
# (e.g. `pod list deprecated`), there are a few things that would need
# to change.
#
# - move this file to `lib/pod/command/list/deprecated.rb` and update
#   the class to exist in the the Pod::Command::List namespace
# - change this class to extend from `List` instead of `Command`. This
#   tells the plugin system that it is a subcommand of `list`.
# - edit `lib/cocoapods_plugins.rb` to require this file
#
# @todo Create a PR to add your plugin to CocoaPods/cocoapods.org
#       in the `plugins.json` file, once your plugin is released.
#

require 'yaml'
require 'rest_client'
require 'colorize'
module Pod
  class Command
    class Ram < Command
      self.summary = "CocoaPods PlugIn to get dependencies on the RAM repository."
      self.description = <<-DESC
        The CocoaPods PlugIn for RAM was created by ton.garcia.jr@gmail.com & is used to:\n
        1. Create a repo workspace;
        2. Get dependencies from the RAM repository;
        3. Update the version of the dependencies from the RAM repo;
        4. Test dependencies folder structure (Lint).
      DESC

      self.arguments = 'NAME'

      def remote_repo_url
        thing = YAML.load_file('some.yml')
      end

      # CocoaPods `pod ram add my-svn-repo http://svn-repo-url` "clones" the repo from the RAM to ~/.cocoapods/repos/NAME
      class Add < Ram
        self.summary = Ram.description
        self.description = Ram.description

        self.arguments = [
            CLAide::Argument.new('NAME', true),
            CLAide::Argument.new('URL', true)
        ]

        def initialize(argv)
          @name, @url = argv.shift_argument, argv.shift_argument
          super
        end

        def validate!
          super
          unless @name && @url
            help! "Adding a spec-repo needs a `NAME` and a `URL`."
          end
        end

        def run
          UI.section("Checking out spec-repo `#{@name}` from `#{@url}` using RAM Connector") do
            puts "\tRAM add command for spec-repo '#{@name}' from '#{@url}' just started".green
            puts "`pod ram add my-svn-repo http://svn-repo-url` \"clones\" the repo from the RAM into ~/.cocoapods/repos/NAME".light_blue

            self.remote_repo_url

            # Create the folder
            system("mkdir ~/.cocoapods/repos/#{@name}")

            # Download the ZIP

            # ZIP Unpacked

            #
          end
        end
      end

      # CocoaPods `pod ram update my-svn-repo http://svn-repo-url` "updates" the repo on ~/.cocoapods/repos/NAME based on the RAM
      class Update < Ram

      end
    end
  end
end
