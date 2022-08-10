# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  permissions :edit?, :destroy?, :update? do
    let!(:admin) { create(:admin) }
    let!(:owner) { create(:user) }
    let!(:non_owner) { create(:user) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(non_owner, { user: owner })
      end

      it 'permits' do
        expect(subject).to permit(owner, { user: owner })
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, { user: owner })
        expect(subject).to permit(admin, { user: non_owner })
      end
    end
  end
end
