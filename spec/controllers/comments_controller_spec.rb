# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:company) { create(:company, user: user1) }
  let!(:membership_1) { create(:membership, company: company, user: user1) }
  let!(:membership_2) { create(:membership, company: company, user: user2) }
  let!(:task) { create(:task, company: company, user: user1) }
  let!(:comment) { create(:comment, task: task, user: user1) }
  before { sign_in user1 }

  describe 'POST #create' do
    let(:params) do
      {
        company_id: company.id,
        task_id: task.id,
        comment: {
          body: 'Test body'
        }
      }
    end
    subject { post :create, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to company_task_path(assigns(:company), assigns(:task)) }

    it 'creates a new comment' do
      subject

      expect(assigns(:task)).to eq task
      expect(assigns(:comment).body).to eq 'Test body'
      expect(assigns(:comment).user).to eq user1
      expect(Comment.count).to eq 2
    end

    it 'cannot create a new comment' do
      params[:comment][:body] = ''
      subject

      expect(response).to redirect_to company_task_path(assigns(:company), assigns(:task))
      expect(response).to have_http_status(:see_other)
    end
  end

  describe 'GET #edit' do
    let(:params) { { company_id: company.id, task_id: task.id, id: comment.id } }
    subject { get :edit, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('edit') }

    it 'returns correct task and comment' do
      subject

      expect(assigns(:task)).to eq task
      expect(assigns(:comment)).to eq comment
    end

    context 'invalid_id' do
      it 'returns an error' do
        params[:id] = 'invalid_id'

        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'not the comment owner' do
      it 'redirects to company_task_path' do
        sign_in user2
        subject

        expect(response).to redirect_to company_task_path(assigns(:company), assigns(:task))
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        company_id: company.id,
        task_id: task.id,
        id: comment.id,
        comment: {
          body: 'Updated body'
        }
      }
    end
    subject { patch :update, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to company_task_path(assigns(:company), assigns(:task)) }

    it 'updates the comment successfully' do
      subject

      expect(assigns(:comment).body).to eq 'Updated body'
    end

    context 'invalid_input' do
      it 'cannot update the comment' do
        params[:comment][:body] = ''
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('edit')
      end
    end

    context 'not the comment owner' do
      it 'redirects to company_task_path' do
        sign_in user2
        subject

        expect(response).to redirect_to company_task_path(assigns(:company), assigns(:task))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { company_id: company.id,  task_id: task.id, id: comment.id } }
    subject { delete :destroy, params: params }

    it { is_expected.to have_http_status(:see_other) }
    it { is_expected.to redirect_to company_task_path(assigns(:company), assigns(:task)) }
    it 'deletes the comment' do
      expect { subject }.to change(Comment, :count).by(-1)
    end

    it 'deletes nothing and redirects to company_task_path' do
      sign_in user2
      subject

      expect(response).to redirect_to company_task_path(assigns(:company), assigns(:task))
      expect(assigns(:comment)).to be_valid
    end
  end
end
