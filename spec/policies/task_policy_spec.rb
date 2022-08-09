# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe TaskPolicy, type: :policy do
  subject { described_class }

  permissions :index?, :show?, :new?, :create? do
    let!(:admin) { create(:admin) }
    let!(:member) { create(:user) }
    let!(:non_member) { create(:user) }
    let!(:company) { create(:company) }
    let!(:membership) { create(:membership, company: company, user: member) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(non_member, { company: company })
      end

      it 'permits' do
        expect(subject).to permit(member, { company: company })
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, { company: company })
      end
    end
  end

  permissions :edit?, :destroy?, :update? do
    let!(:admin) { create(:admin) }
    let!(:owner) { create(:user) }
    let!(:non_owner) { create(:user) }
    let!(:task) { create(:task, user: owner) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(non_owner, { task: task })
      end

      it 'permits' do
        expect(subject).to permit(owner, { task: task })
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, { task: task })
      end
    end
  end
end
