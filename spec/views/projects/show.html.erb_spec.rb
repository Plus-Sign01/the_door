require 'rails_helper'

RSpec.describe "projects/show", :type => :view do
  context '未ログインユーザがアクセスしたとき'
  before do 
  	allow(view).to receive(:logged_in?) { false }
  	allow(view).to receive(:current_user) { nil }
   end
context 'かつ@project.owner　が　nil　のとき' do

       before do
       	  assign(:project, create(:project, owner: id))
       	  assign(:participation, [])
       end
       
       it '"退会したユーザです"と表示されていること' do

           render
           expect(rendered).to match /退会したユーザです/
       end
   end
   end
end
