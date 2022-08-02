# frozen_string_literal: true

RSpec.describe UsersController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  describe 'GET #show' do
    let(:params) { { id: user1.id } }
    before { sign_in user1 }
    subject { get :show, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('show') }
  end

  describe 'GET #edit' do
    let(:params) { { id: user1.id } }
    subject { get :edit, params: params }

    context 'authorized' do
      before { sign_in user1 }

      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to render_template('edit') }
    end

    context 'unauthorized' do
      before { sign_in user2 }

      it { is_expected.to redirect_to user_path(assigns(:user)) }
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        id: user1.id,
        user: {
          avatar: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/example_2.png')),
          username: 'Test username'
        }
      }
    end
    before { sign_in user1 }
    subject { post :update, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to user_path(assigns(:user)) }
    it 'updates new avatar' do
      subject
      expect(assigns(:user).username).to eq 'Test username'
      expect(assigns(:user).avatar.file.filename).to eq params[:user][:avatar].original_filename
    end
  end
end
