require 'spec_helper'


describe "Project" do 
      describe '#name' do 
      	it { should validate_presence_of(:name) }
      	it { should ensure_length_of(:name).is_at_most(50) }
      end

      describe '#place' do
      	it { should validate_presence_of(:place) }
      	it { should ensure_length_of(:place).is_at_most(100) }
      end
      
      describe '#content' do
      	it { should validate_presence_of(:content) }
      	it { should ensure_length_of(:content).is_at_most(2000) }
      end

      describe '#start_time' do
      	it { should validate_presence_of(:start_time) }
      	it { should ensure_length_of(:start_time) }

      end
      describe '#end_time' do
      	it { should validate_presence_of(:end_time) }
      	it { should ensure_length_of(:end_time) }
      end
      describe '#content' do
      	it { should validate_presence_of(:content) }
      	it { should ensure_length_of(:content).is_at_most(2000) }
      end
	
end