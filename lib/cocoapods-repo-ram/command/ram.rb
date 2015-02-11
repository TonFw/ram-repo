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
require 'zipruby'
require 'net/http'
require 'rest_client'
module Pod
  class Command
    class Ram < Command
      attr_accessor :yml
      attr_accessor :url_hash

      self.summary = "CocoaPods PlugIn to get dependencies on the RAM repository."
      self.description = <<-DESC
        The CocoaPods PlugIn for RAM was created by ton.garcia.jr@gmail.com & is used to:\n
        1. Create a repo workspace;
        2. Get dependencies from the RAM repository;
        3. Update the version of the dependencies from the RAM repo;
        4. Test dependencies folder structure (Lint).
      DESC

      self.arguments = 'NAME'

      def get_url
        YAML.open
        req = self.yml[:dev]
        req[:protocol]+req[:domain]+req[:path]
      end

      def strip_url
        url_split = @url.split('/')

        self.url_hash = {} if self.url_hash.nil?
        self.url_hash[:protocol] = @url[0..@url.index('//')-2]
        self.url_hash[:domain] = url_split[2]
        self.url_hash[:path] = @url[@url.index(self.url_hash[:domain])-1, @url.length]
      end

      # @return [system_call execution]
      def download!
        file_name = 'pods.zip'
        curl_cmd = 'curl -f -L -o'
        cmd = "#{curl_cmd} #{file_name} #{@url} --create-dirs"

        system(cmd)
      end

      # UnZIP the files to the Directory
      def unzip

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
          @url = self.get_url if @url.nil?

          self.strip_url
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
            puts "\tRAM add command for spec-repo '#{@name}' from '#{@url}' cloning into ~/.cocoapods/repos/#{@name}".green

            # Create the folder
            system("mkdir ~/.cocoapods/repos/#{@name}")

            # Download the ZIP
            downloaded = self.download!
            puts "Error while downloading from #{@url}".red unless downloaded

            # ZIP Unpacked
            self.unzip
          end
        end
      end

      # CocoaPods `pod ram update my-svn-repo` "updates" the repo on ~/.cocoapods/repos/NAME based on the RAM
      class Update < Ram
        self.summary = Ram.description
        self.description = Ram.description

        self.arguments = [
            CLAide::Argument.new('NAME', true)
        ]

        def initialize(argv)
          @name = argv.shift_argument
          super
        end

        def validate!
          super
          unless @name
            help! "Updating a spec-repo needs a `NAME`."
          end
        end

        def run

        end
      end

      # CocoaPods `pod ram remove my-svn-repo` "removes" the repo on ~/.cocoapods/repos/NAME
      class Remove < Ram
        self.summary = Ram.description
        self.description = Ram.description

        self.arguments = [
            CLAide::Argument.new('NAME', true)
        ]

        def initialize(argv)
          @name = argv.shift_argument
          super
        end

        def validate!
          super
          unless @name
            help! "Removing a spec-repo needs a `NAME`."
          end
        end

        def run

        end
      end
    end
  end
end
