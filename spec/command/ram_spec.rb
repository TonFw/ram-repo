require 'spec_helper'

module Pod
  describe Command::Ram do
    describe 'CLAide' do
      it 'registers it self' do
        argv = CLAide::ARGV.new(['ram-repo', 'https://github.com/CocoaPods/Specs/archive/master.zip'])
        add = Pod::Command::Ram::Add.new argv
        Command.parse(%w{ ram }).should.be.instance_of Command::Ram
      end
    end
  end
end