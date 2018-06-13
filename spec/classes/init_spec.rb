require 'spec_helper'
describe 'openhab2' do

  context 'with defaults for all parameters' do
    it { should contain_class('openhab2') }
  end
end
