require 'spec_helper'

module Pod
  describe Command::Ram do
    @repo_name = 'ram-repo'
    @repo_url  = 'https://alm.intranet.bb.com.br/ram/artifact/502E0D4B-726B-AC6D-863D-6BD85050ACB8/1.0'

    before(:all) do
      @repo_name = 'ram-repo'
      @repo_url  = 'https://alm.intranet.bb.com.br/ram/artifact/502E0D4B-726B-AC6D-863D-6BD85050ACB8/1.0'
      @argv = CLAide::ARGV.new([@repo_name, @repo_url])

      @add_command    = Command::Ram::Add.new @argv
      @update_command = Command::Ram::Update.new @argv
      @remove_command = Command::Ram::Remove.new @argv
    end

    describe 'CLAide ram running correctly' do
      it 'registers it self' do
        Command.parse(%w{ ram }).should.be.instance_of Command::Ram
      end
    end

    describe "pod ram add #{@repo_name} #{@repo_url} " do
      before(:all) do
        @add_command.run
      end

      it 'named repo should be created at ~/.cocoapods/repos/repo_name' do
        expect(`ls ~/.cocoapods/repos`.index(@repo_name)).to_not be_nil
      end

      it 'should have the Specs, should not be empty' do
        pending 'check if the Specs were cloned'
        this_should_not_get_executed
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