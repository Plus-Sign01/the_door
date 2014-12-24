require 'spec_helper'
describe 'ユーザがイベントの参加や登録を行うために、ログインをする' do
	context 'トップページに遷移し、"facebookでログイン"をクリックしたとき'　do
		context 'かつfacebookでのログインに成功したとき' do 
			before do
			visit root_path
			click_link 'facebookでログイン'	
			end
			it 'トップページに遷移していること' do
				expect(page.current_path).to eq root_path
			end
			it '"ログインしました"と表示されること' do 
				expect(page).to have_content 'ログインしました'

				
			end
		end


			
		end

		
end