# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:company) { create(:company) }
  let!(:membership) { create(:membership, user: user, company: company) }

  before { sign_in user }

  describe 'GET #index' do
    let(:params) { { company_id: company.id } }
    subject { get :index, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('index') }

    it 'returns all memberships' do
      subject

      expect(assigns(:memberships)).to match_array [membership]
    end
  end

  describe 'GET #new' do
    let(:params) { { company_id: company.id } }
    subject { get :new, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('new') }
    it 'creates a new instance' do
      subject

      expect(assigns(:membership)).to be_instance_of Membership
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        company_id: company.id,
        membership: {
          email: user.email
        }
      }
    end
    subject { post :create, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to company_memberships_path }

    it 'creates a membership' do
      expect { subject }.to change(Membership, :count).by(1)
    end

    it 'creates a new membership' do
      subject

      expect(assigns(:membership).company_id).to eq company.id
      expect(assigns(:membership).user_id).to eq user.id
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { company_id: company.id, id: membership.id } }
    subject { delete :destroy, params: params }

    it { is_expected.to have_http_status(:see_other) }
    it { is_expected.to redirect_to company_memberships_path }

    it 'deletes the member' do
      expect { subject }.to change(Membership, :count).by(-1)
    end
  end
end
