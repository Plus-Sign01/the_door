require 'spec_helper'

describe Project do 
	describe '#name' do 
　　　　　context '空白のとき' do
	      let(:project) { Project.new(name: '') }
	      
          it 'validでないこと' do 
          	project = Project.new(name: '')
          	project.valid?
          	expect(project.errors[:name]).to be_present
          end

          	
          end
		
	end


	
end
