# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:task1) { create(:task) }
  let!(:task2) { create(:task, status: :done) }

  describe 'GET #index' do
    subject { get :index }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('index') }

    it 'returns all tasks' do
      subject
      expect(assigns(:tasks)).to match_array [task1, task2]
    end
  end

  describe 'GET #show' do
    let(:params) { { id: task1.id } }
    subject { get :show, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('show') }

    it 'returns task1' do
      subject

      expect(assigns(:task)).to eq task1
    end

    it 'raises an error' do
      params[:id] = 'invalid_id'

      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    subject { get :new }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('new') }

    it 'creates new instance' do
      subject

      expect(assigns(:task).title).to eq ''
      expect(assigns(:task).body).to eq ''
      expect(assigns(:task).status).to eq 'pending'
    end
  end

  describe 'POST #create' do
    let(:params) do
      { task: { title: 'Title-1', body: 'This is a body' } }
    end
    subject { post :create, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to root_url }

    it 'creates a new task' do
      subject

      expect(assigns(:task).title).to eq 'Title-1'
      expect(assigns(:task).body).to eq 'This is a body'
      expect(assigns(:task).status).to eq 'pending'
      expect(Task.count).to eq 3
    end

    it 'cannot create a new task' do
      params[:task][:body] = ''
      subject

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    let(:params) { { id: task1.id } }
    subject { get :edit, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('edit') }

    it 'returns the task' do
      subject

      expect(assigns(:task)).to eq task1
    end

    it 'returns an error' do
      params[:id] = 'invalid_id'

      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      { id: task2.id, task: { title: 'updated Title', body: 'This is updated body', status: 'in_progress' } }
    end
    subject { post :update, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to task_path(assigns(:task)) }

    it 'updates the task' do
      subject

      expect(assigns(:task).title).to eq 'updated Title'
      expect(assigns(:task).body).to eq 'This is updated body'
      expect(assigns(:task).status).to eq 'in_progress'
    end

    it 'connot update the task' do
      params[:task][:body] = ''
      subject

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { id: task1.id } }
    subject { delete :destroy, params: params }

    it { is_expected.to have_http_status(:see_other) }
    it { is_expected.to redirect_to root_url }

    it 'deletes the task' do
      expect { subject }.to change(Task, :count).by(-1)
    end
  end
end
