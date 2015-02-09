require 'colorize'
module Pod
  class Command
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

      # CocoaPods Add command implementation
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
            config.repos_dir.mkpath
            Dir.chdir(config.repos_dir) do
              #command = "checkout --non-interactive --trust-server-cert '#{@url}' #{@name}"
              #!svn(command)
            end
          end
        end
      end

      # def initialize(argv)
      #   @name = argv.shift_argument
      #   super
      # end
      #
      # def validate!
      #   super
      #   help! "A Pod name is required." unless @name
      # end
      #
      # def run
      #   UI.puts "Add your implementation for the cocoapods-repo-ram plugin in #{__FILE__}"
      # end
    end
  end
end
