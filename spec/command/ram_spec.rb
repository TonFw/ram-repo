require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Ram do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ ram }).should.be.instance_of Command::Ram
      end
    end
  end
end

