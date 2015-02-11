require 'spec_helper'

module Pod
  describe Command::Ram do
    @repo_name = 'ram-repo'
    @repo_url  = 'http://ram.intranet.bb.com.br/archiva/repository/repo/junit/junit/3.8.2/junit-3.8.2.jar'

    before(:all) do
      # TODO change it to Specs when it came up
      @libs_folder = 'junit'
      @repo_name = 'ram-repo'
      @repo_url  = 'http://ram.intranet.bb.com.br/archiva/repository/repo/junit/junit/3.8.2/junit-3.8.2.jar'

      @add_command    = Command::Ram::Add.new create_argv @repo_name
      @update_command = Command::Ram::Update.new create_argv @repo_name
      @remove_command = Command::Ram::Remove.new create_argv @repo_name
      @add_command_url= Command::Ram::Add.new create_argv_with_url @repo_name, @repo_url
    end

    describe 'CLAide ram running correctly' do
      it 'registers it self' do
        Command.parse(%w{ ram }).should.be.instance_of Command::Ram
      end
    end

    describe "pod ram add #{@repo_name} #{@repo_url}" do
      before(:all) do
        @add_command_url.run
      end

      it 'named repo should be created at ~/.cocoapods/repos/repo_name' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to_not be_nil
      end

      it 'should have the Specs, should not be empty' do
        cmd_resp = `ls ~/.cocoapods/repos/ram-repo`
        expect(cmd_resp).to_not be_empty
        expect(cmd_resp.index(@libs_folder)).to_not be_nil
      end
    end

    describe "pod ram add #{@repo_name} without passing URL on the CMD (static on the YML)" do
      before(:all) do
        @add_command.run
      end

      it 'named repo should be created at ~/.cocoapods/repos/repo_name' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to_not be_nil
      end

      it 'should have the Specs, should not be empty' do
        cmd_resp = `ls ~/.cocoapods/repos/ram-repo`
        expect(cmd_resp).to_not be_empty
        expect(cmd_resp.index(@libs_folder)).to_not be_nil
      end
    end

    describe "pod ram update #{@repo_name}" do
      before(:all) do
        @update_command.run
      end

      it 'framework versions should be updated' do
        pending 'check if the Specs frameworks versions updated'
        this_should_not_get_executed
      end

      it 'the folder creation date should be updated' do
        pending 'check if the folder create time was near now'
        this_should_not_get_executed
      end
    end

    describe "pod ram remove #{@repo_name}" do
      before(:all) do
        @remove_command.run
      end

      it 'folder on ~/.cocoapods/repos/repo_name should not exists anymore' do
        pending 'check if the repo_name & Specs were removed'
        this_should_not_get_executed
      end
    end
  end
end