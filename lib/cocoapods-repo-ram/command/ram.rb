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

      def ram_tag
        "PodsRAM says: "
      end

      def repo_dir
        "#{config.repos_dir}/#{@name}"
      end
      
      # Retrieve the URL from the config file 
      def get_url
        return @url if @url

        yml = YAML::load_file("#{repo_dir}/.ram_config")
        yml = yml.it_keys_to_sym
        @url = yml[:url]

        UI.puts "-> error while reading the YML #{e.to_s}".red if @url.nil?
        @url
      end

      def download!
        `rm -rf pods.zip`
        file_name = 'pods.zip'
        curl_cmd = 'curl -f -L -o'
        cmd = "#{curl_cmd} #{file_name} #{get_url} --create-dirs"

        system cmd
      end

      def unzip!
        `rm -rf #{repo_dir}/Specs`
        cmd = "unzip pods.zip -d #{repo_dir}/Specs"
        system cmd
      end

      # CocoaPods `pod ram add my-ram-repo http://svn-repo-url` "clones" the repo from the RAM to #{config.repos_dir}/NAME
      class Add < Ram
        self.summary = Ram.description
        self.description = Ram.description

        self.arguments = [
            CLAide::Argument.new('NAME', true),
            CLAide::Argument.new('URL', true)
        ]

        def initialize(argv)
          @argv = argv
          @name, @url = @argv.shift_argument, @argv.shift_argument
          UI.puts "-> pods RAM add command need a valida URL".red if @url.nil?

          validate!
          self.strip_url if @url.nil?
          super
        end

        def validate!
          super
          help! "Adding a spec-repo needs a `NAME` and a `URL`." unless @name && @url
        end

        # Create the YML with the URL passed
        def create_config_file
          f = File.open("#{repo_dir}/.ram_config",  "w+")
          f.write "url: #{@url}"
          f.close
        end

        def run
          UI.section("Checking out spec-repo `#{@name}` from `#{@url}` using RAM Connector") do
            config.repos_dir.mkpath
            puts "#{ram_tag} RAM add command for spec-repo '#{@name}' from '#{@url}' cloning into #{repo_dir}".green

            # Prepare the repo folder
            `rm -rf #{repo_dir}`
            `mkdir #{repo_dir}`
            create_config_file

            # Download the ZIP
            downloaded = self.download!
            puts "#{ram_tag} Error while downloading from #{@url}".red unless downloaded

            # ZIP Unpacked
            unzipped = self.unzip!
            puts "#{ram_tag} Error while unzipping from `pods.zip`".red unless unzipped
          end
        end
      end

      # CocoaPods `pod ram update my-ram-repo` "updates" the repo on #{config.repos_dir}/NAME based on the RAM
      class Update < Ram
        self.summary = Ram.description
        self.description = Ram.description

        self.arguments = [
            CLAide::Argument.new('NAME', true)
        ]

        def initialize(argv)
          @argv = argv.clone
          @name = @argv.shift_argument

          validate!
          super
        end

        def validate!
          super
          help! "Updating a spec-repo needs a `NAME`." unless @name
        end

        def run
          # Prepare the repo folder
          `rm -rf #{repo_dir}/Specs`

          # Download the ZIP
          downloaded = self.download!
          puts "#{ram_tag} Error while downloading from #{@url}".red unless downloaded

          # ZIP Unpacked
          unzipped = self.unzip!
          puts "#{ram_tag} Error while unzipping from #{pods.zip}".red unless unzipped
        end
      end

      # CocoaPods `pod ram remove my-ram-repo` "removes" the repo on #{config.repos_dir}/NAME
      class Remove < Ram
        self.summary = Ram.description
        self.description = Ram.description

        self.arguments = [
            CLAide::Argument.new('NAME', true)
        ]

        def initialize(argv)
          @argv = argv
          @name = @argv.shift_argument

          validate!
          super
        end

        def validate!
          super
          help! "Removing a spec-repo needs a `NAME`." unless @name
        end

        def run
          system("rm -rf #{repo_dir}") unless @name.nil?
        end
      end

      # CocoaPods `pod ram lint my-ram-repo` "test" the repo on #{config.repos_dir}/NAME to know if it format is correct
      class Lint < Ram
        self.summary = 'Validates all specs in a repo.'

        self.description = <<-DESC
          Lints the spec-repo `NAME`. If a directory is provided it is assumed
          to be the root of a repo. Finally, if `NAME` is not provided this
          will lint all the spec-repos known to CocoaPods.
        DESC

        self.arguments = [
            CLAide::Argument.new(%w(NAME DIRECTORY), true)
        ]

        def self.options
          [["--only-errors", "Lint presents only the errors"]].concat(super)
        end

        def initialize(argv)
          @name = argv.shift_argument
          @only_errors = argv.flag?('only-errors')
          super
        end

        # @todo Part of this logic needs to be ported to cocoapods-core so web
        #       services can validate the repo.
        #
        # @todo add UI.print and enable print statements again.
        #
        def run
          @name ? dirs = File.exists?(@name) ? [ Pathname.new(@name) ] : [ repo_dir ] : dirs = config.repos_dir.children.select {|c| c.directory?}

          dirs.each do |dir|
            SourcesManager.check_version_information(dir) #todo: test me
            UI.puts "\nLinting spec repo `#{@name}`\n".yellow

            validator = Source::HealthReporter.new(dir)
            validator.pre_check do |name, version|
              UI.print '.'
            end
            report = validator.analyze
            UI.puts
            UI.puts

            report.pods_by_warning.each do |message, versions_by_name|
              UI.puts "-> #{message}".yellow
              versions_by_name.each { |name, versions| UI.puts "  - #{name} (#{versions * ', '})" }
              UI.puts
            end

            report.pods_by_error.each do |message, versions_by_name|
              UI.puts "-> #{message}".red
              versions_by_name.each { |name, versions| UI.puts "  - #{name} (#{versions * ', '})" }
              UI.puts
            end

            UI.puts "Analyzed #{report.analyzed_paths.count} podspecs files.\n\n"
            if report.pods_by_error.count.zero?
              UI.puts "All the specs passed validation.".green << "\n\n"
            else
              raise Informative, "#{report.pods_by_error.count} podspecs failed validation."
            end
          end
        end
      end
    end
  end
end
