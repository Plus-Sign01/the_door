require 'spec_helper'

describe ProjectsController do
	describe 'Get #new' do 
		context '未ログインユーザがアクセスしたとき' do 
		  before { get :new }

		  it 'トップページにリダイレクトすること' do
		  	expect(response).to redirect_to(root_path)
		  end
			
		end

		context "ログインユーザがアクセスしたとき" do
			before do
				user = create :user
				session[:user_id] = user.id
				get :new
		end

		it 'ステータスコードとして200が返ること' do 
			expect(response.status).to eq(200)
            
			
		end
		it '@projectに、新規projectオブジェクトが格納されていること' do
			expect(assigns(:project)).to be_a_new(Project)
		end

		it 'newテンプレートをrenderしていること' do
			expect(response).to render_template :new
		end
		

		end

		
	end

end
