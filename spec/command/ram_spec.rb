require 'spec_helper'

module Pod
  describe Command::Ram do
    @repo_name = 'ram-repo'
    @repo_url  = 'http://ram.intranet.bb.com.br/archiva/repository/repo/junit/junit/3.8.2/junit-3.8.2.jar'

    before(:all) do
      # TODO change it to Specs when it came up
      @libs_folder = 'Specs'
      @repo_name = 'ram-repo'
      @repo_url  = 'http://ram.intranet.bb.com.br/archiva/repository/repo/junit/junit/3.8.2/junit-3.8.2.jar'
      @repo_dir = "#{root_dir}/.cocoapods/repos/#{@repo_name}"

      @update_command = Command::Ram::Update.new create_argv @repo_name
      @remove_command = Command::Ram::Remove.new create_argv @repo_name
      @lint_command   = Command::Ram::Lint.new create_argv @repo_name
      @add_command    = Command::Ram::Add.new create_argv_with_url @repo_name, @repo_url
    end

    describe 'CLAide ram running correctly' do
      it 'registers it self' do
        Command.parse(%w{ ram }).should.be.instance_of Command::Ram
      end
    end

    describe "pod ram add #{@repo_name} #{@repo_url}" do
      before(:all) do
        @add_command.run
      end

      it 'named repo should be created at ~/.cocoapods/repos/repo_name' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to_not be_nil
      end

      it 'should have the Specs, should not be empty' do
        cmd_resp = `ls ~/.cocoapods/repos/#{@repo_name}`
        expect(cmd_resp).to_not be_empty
        expect(cmd_resp.index(@libs_folder)).to_not be_nil
      end

      it 'should have the YML config file with it URL' do
        yml = YAML::load_file("#{@repo_dir}/.ram_config")
        expect(yml).to be_a Hash
        yml = yml.it_keys_to_sym
        expect(yml[:url]).to eq(@repo_url)
      end
    end

    describe "pod ram update #{@repo_name}" do
      before(:all) do
        @update_command.run
      end

      it 'framework versions should be updated' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to_not be_nil
      end

      it 'the folder creation date should be updated' do
        cmd_resp = `ls ~/.cocoapods/repos/ram-repo`
        expect(cmd_resp).to_not be_empty
        expect(cmd_resp.index(@libs_folder)).to_not be_nil
      end
    end

    describe "pod ram lint #{@repo_name}" do
      before(:all) do
        @lint_command.run
      end

      it 'folder on ~/.cocoapods/repos/repo_name should not exists anymore' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to be_nil
      end
    end

    describe "pod ram remove #{@repo_name}" do
      before(:all) do
        @remove_command.run
      end

      it 'folder on ~/.cocoapods/repos/repo_name should not exists anymore' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to be_nil
      end
    end
  end
end