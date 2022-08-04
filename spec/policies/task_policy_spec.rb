# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe TaskPolicy, type: :policy do
  subject { described_class }

  permissions :update?, :edit?, :destroy? do
    let!(:user) { create(:user_role) }
    let!(:admin) { create(:admin_role) }
    let!(:task1) { create(:task, user: user) }
    let!(:task2) { create(:task, user: admin) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(user, task2)
      end

      it 'permits' do
        expect(subject).to permit(user, task1)
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, task1)
        expect(subject).to permit(admin, task2)
      end
    end
  end
end
