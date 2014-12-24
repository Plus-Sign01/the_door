require 'spec_helper'


describe "Project" do 
      describe '#name' do 
      	it { should validate_presence_of(:name) }
      	it { should ensure_length_of(:name).is_at_most(50) }
      end
	
end