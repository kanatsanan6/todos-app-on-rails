# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  permissions :update?, :edit? do
    let!(:user) { create(:user_role) }
    let!(:admin) { create(:admin_role) }

    context 'user' do
      it 'denies' do
        expect(subject).not_to permit(user, admin)
      end

      it 'permits' do
        expect(subject).to permit(user, user)
      end
    end

    context 'admin' do
      it 'permits' do
        expect(subject).to permit(admin, user)
      end
    end
  end
end
