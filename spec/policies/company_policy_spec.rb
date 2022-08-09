# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe CompanyPolicy, type: :policy do
  subject { described_class }

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
