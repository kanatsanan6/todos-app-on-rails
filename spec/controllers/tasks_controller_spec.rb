# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:company) { create(:company, user: user1) }
  let!(:membership_1) { create(:membership, company: company, user: user1) }
  let!(:membership_2) { create(:membership, company: company, user: user2) }
  let!(:task1) { create(:task, title: 'Title task1', company: company, user: user1) }
  let!(:task2) { create(:task, company: company, user: user2, status: :done) }
  let!(:task3) { create(:task, company: company, user: user1, status: :done) }
  let!(:task4) { create(:task, company: company, user: user2, scope: :scope_private) }
  let!(:task5) { create(:task, company: company, user: user1, status: :done, scope: :scope_private) }

  before { sign_in user1 }

  describe 'GET #index' do
    context 'w/o search filter' do
      let(:params) { { company_id: company.id } }
      subject { get :index, params: params }

      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to render_template('index') }

      it 'returns all tasks' do
        subject

        expect(assigns(:tasks)).to match_array [task1, task2, task3, task5]
      end
    end

    context 'w/ search filter' do
      let(:params) { { company_id: company.id, search: { status: 2, user_id: user1.id } } }
      subject { get :index, params: params }

      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to render_template('index') }

      it 'returns task3 and task5' do
        subject

        expect(assigns(:tasks)).to match_array [task3, task5]
      end

      it 'return only task1' do
        params[:search][:title] = 'task1'
        params[:search][:status] = 1
        subject

        expect(assigns(:tasks)).to match_array [task1]
      end

      it 'returns only task5' do
        params[:search][:scope] = :scope_private
        subject

        expect(assigns(:tasks)).to match_array [task5]
      end
    end
  end

  describe 'GET #show' do
    let(:params) { { company_id: company.id, id: task1.id } }
    subject { get :show, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('show') }

    it 'returns task1' do
      subject

      expect(assigns(:task)).to eq task1
    end

    it 'redirects to company_tasks' do
      params[:id] = task4.id
      subject

      expect(response).to redirect_to company_tasks_path(assigns(:company))
    end

    it 'raises an error' do
      params[:id] = 'invalid_id'

      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    let(:params) { { company_id: company.id } }
    subject { get :new, params: params }

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
      {
        company_id: company.id,
        task: {
          title: 'Title-1',
          body: 'This is a body'
        }
      }
    end
    subject { post :create, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to company_tasks_path(assigns(:company)) }

    it 'creates a new task' do
      subject

      expect(assigns(:task).title).to eq 'Title-1'
      expect(assigns(:task).body).to eq 'This is a body'
      expect(assigns(:task).status).to eq 'pending'
      expect(Task.count).to eq 6
    end

    it 'cannot create a new task' do
      params[:task][:body] = ''
      subject

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    let(:params) { { company_id: company.id, id: task1.id } }
    subject { get :edit, params: params }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('edit') }

    it 'returns the task' do
      subject

      expect(assigns(:task)).to eq task1
    end

    context 'invalid_id' do
      it 'returns an error' do
        params[:id] = 'invalid_id'

        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'not the task owner' do
      it 'redirects to company_tasks' do
        sign_in user2
        subject

        expect(response).to redirect_to company_tasks_path(assigns(:company))
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        company_id: company.id,
        id: task1.id,
        task: {
          title: 'updated Title',
          body: 'This is updated body',
          status: 'in_progress'
        }
      }
    end
    subject { post :update, params: params }

    it { is_expected.to have_http_status(302) }
    it { is_expected.to redirect_to company_task_path(assigns(:company), assigns(:task)) }

    it 'updates the task' do
      subject

      expect(assigns(:task).title).to eq 'updated Title'
      expect(assigns(:task).body).to eq 'This is updated body'
      expect(assigns(:task).status).to eq 'in_progress'
    end

    context 'invalid_input' do
      it 'connot update the task' do
        params[:task][:body] = ''
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('edit')
      end
    end

    context 'not the task owner' do
      it 'redirects to root_url' do
        sign_in user2
        subject

        expect(response).to redirect_to company_tasks_path(assigns(:company))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { company_id: company.id, id: task1.id } }
    subject { delete :destroy, params: params }

    it { is_expected.to have_http_status(:see_other) }
    it { is_expected.to redirect_to company_tasks_path(assigns(:company)) }

    it 'deletes the task' do
      expect { subject }.to change(Task, :count).by(-1)
    end

    it 'deletes nothing and redirects to company_tasks' do
      sign_in user2
      subject

      expect(response).to redirect_to company_tasks_path(assigns(:company))
      expect(assigns(:task)).to be_valid
    end
  end
end
