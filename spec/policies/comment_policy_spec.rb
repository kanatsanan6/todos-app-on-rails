# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class }

  permissions :update?, :edit?, :destroy? do
    let!(:user) { create(:user_role) }
    let!(:admin) { create(:admin_role) }
    let!(:task) { create(:task, user: user) }
    let!(:comment1) { create(:comment, task: task, user: user) }
    let!(:comment2) { create(:comment, task: task, user: admin) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(user, comment2)
      end

      it 'permits' do
        expect(subject).to permit(user, comment1)
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, comment1)
        expect(subject).to permit(admin, comment2)
      end
    end
  end
end
