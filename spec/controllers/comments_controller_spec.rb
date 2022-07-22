# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:task) { create(:task) }
  let!(:comment) { create(:comment, task: task) }

  describe 'POST #create' do
    let(:params) do
      { task_id: task.id, comment: { commenter: 'Test commenter', body: 'Test body' } }
    end
    subject { post :create, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to task_path(assigns(:task)) }

    it 'creates a new comment' do
      subject

      expect(assigns(:task)).to eq task
      expect(assigns(:comment).commenter).to eq 'Test commenter'
      expect(assigns(:comment).body).to eq 'Test body'
      expect(Comment.count).to eq 2
    end

    it 'cannot create a new comment' do
      params[:comment][:commenter] = ''
      subject

      expect(response).to redirect_to task_path(assigns(:task))
    end
  end

  describe 'GET #edit' do
    let(:params) { { task_id: task.id, id: comment.id } }
    subject { get :edit, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('edit') }

    it 'returns correct task and comment' do
      subject

      expect(assigns(:task)).to eq task
      expect(assigns(:comment)).to eq comment
    end

    it 'returns an error' do
      params[:id] = 'invalid_id'

      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      { task_id: task.id, id: comment.id, comment: { commenter: 'Updated commenter', body: 'Updated body' } }
    end
    subject { patch :update, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to task_path(assigns(:task)) }

    it 'updates the comment successfully' do
      subject

      expect(assigns(:comment).commenter).to eq 'Updated commenter'
      expect(assigns(:comment).body).to eq 'Updated body'
    end

    it 'cannot update the comment' do
      params[:comment][:commenter] = ''
      subject

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { task_id: task.id, id: comment.id } }
    subject { delete :destroy, params: params }

    it { is_expected.to have_http_status(:see_other) }
    it { is_expected.to redirect_to task_path(assigns(:task)) }
    it 'deletes the comment' do
      expect { subject }.to change(Comment, :count).by(-1)
    end
  end
end
