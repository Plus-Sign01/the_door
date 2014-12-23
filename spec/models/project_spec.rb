require 'spec_helper'

describe Project do
	describe '#name' do
		example '空白のとき' do
　　　　 let(:project) { Project.new(name: '') }

           it 'valid でないこと' do 
          	project.valid?
          	expect(project.errors[:name]).to be_present
          end

          	
          end
		
	end


	
end
