require 'spec_helper'

describe "Participation" do
	describe "#school" do 
	    it { should validate_presence_of(:school) }
	    it { should ensure_length_of(:school) }
		
	end
	describe "#language" do
		it { should validate_presence_of(:language) }
		it { should ensure_length_of(:language) }
	end
	describe "#skill" do 
        it { should validate_presence_of(:skill) }
        it { should ensure_length_of(:skill) }
		
	end
	describe "#comment" do
		it { should validate_presence_of(:comment) }
		it { should ensure_length_of(:comment).is_at_most(140) }
	end

  
end
