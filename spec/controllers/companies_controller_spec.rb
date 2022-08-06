# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:company1) { create(:company) }
  let!(:company2) { create(:company) }

  before { sign_in user }

  describe 'GET #index' do
    subject { get :index }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('index') }

    it 'returns all companies' do
      subject

      expect(assigns(:companies)).to match_array [company1, company2]
    end
  end

  describe 'GET #new' do
    subject { get :new }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('new') }

    it 'creates new instance' do
      subject

      expect(assigns(:company).name).to eq ''
      expect(assigns(:company).user).to eq nil
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        company: {
          name: 'Name-1'
        }
      }
    end
    subject { post :create, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to companies_path }

    it 'creates a new company' do
      subject

      expect(assigns(:company).name).to eq 'Name-1'
      expect(assigns(:company).user_id).to eq user.id
      expect(Company.count).to eq 3
    end

    it 'cannot create a new task' do
      params[:company][:name] = ''
      subject

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    let(:params) { { id: company1.id } }
    subject { get :edit, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('edit') }

    it 'returns the company' do
      subject

      expect(assigns(:company)).to eq company1
    end

    context 'invalid_id' do
      it 'returns an error' do
        params[:id] = 'invalid_id'

        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        id: company1.id,
        company: {
          name: 'updated Name'
        }
      }
    end
    subject { post :update, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to companies_path }

    it 'updates the company' do
      subject

      expect(assigns(:company).name).to eq 'updated Name'
    end

    context 'invalid_input' do
      it 'connot update the company' do
        params[:company][:name] = ''
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { id: company1.id } }
    subject { delete :destroy, params: params }

    it { is_expected.to have_http_status(:see_other) }
    it { is_expected.to redirect_to companies_path }

    it 'deletes the company' do
      expect { subject }.to change(Company, :count).by(-1)
    end
  end
end
