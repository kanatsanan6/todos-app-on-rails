# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'valid factory' do
    subject { build(:company) }

    it { is_expected.to be_valid }
  end

  describe 'validations and associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:users).through(:memberships) }
    it { is_expected.to validate_presence_of :name }
  end
end
