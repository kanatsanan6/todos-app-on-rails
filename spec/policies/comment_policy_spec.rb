# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class }

  permissions :create? do
    let!(:admin) { create(:admin) }
    let!(:member) { create(:user) }
    let!(:non_member) { create(:user) }
    let!(:company) { create(:company, user: member) }
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
    let!(:comment) { create(:comment, user: owner) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(non_owner, { comment: comment })
      end

      it 'permits' do
        expect(subject).to permit(owner, { comment: comment })
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, { comment: comment })
      end
    end
  end
end
