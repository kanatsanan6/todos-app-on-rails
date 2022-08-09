# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe CompanyPolicy, type: :policy do
  subject { described_class }

  describe 'Scope' do
    let!(:admin) { create(:admin) }
    let!(:non_member) { create(:user) }
    let!(:member) { create(:user) }
    let!(:company_1) { create(:company, user: member) }
    let!(:company_2) { create(:company) }
    let!(:membership) { create(:membership, company: company_1, user: member) }

    context 'member' do
      let!(:scope) { Pundit.policy_scope(member, Company) }
      it 'returns company' do
        expect(scope.to_a).to match_array [company_1]
      end
    end

    context 'non member' do
      let!(:scope) { Pundit.policy_scope(non_member, Company) }
      it 'returns nothing' do
        expect(scope.to_a).to match_array []
      end
    end

    context 'admin' do
      let!(:scope) { Pundit.policy_scope(admin, Company) }
      it 'returns company' do
        expect(scope.to_a).to match_array [company_1, company_2]
      end
    end
  end

  permissions :edit?, :update?, :destroy? do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin) }
    let!(:company_user) { create(:company, user: user) }
    let!(:company_admin) { create(:company, user: admin) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(user, { company: company_admin })
      end

      it 'permits' do
        expect(subject).to permit(user, { company: company_user })
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, { company: company_admin })
        expect(subject).to permit(admin, { company: company_user })
      end
    end
  end
end
