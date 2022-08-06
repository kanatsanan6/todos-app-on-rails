# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid factory' do
    subject { build(:user) }

    it { is_expected.to be_valid }
  end

  describe 'validations and associations' do
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:companies) }
    it { is_expected.to have_many(:membership) }
    it { is_expected.to have_many(:companies).through(:membership) }
    it { should define_enum_for(:role).with_values(user: 0, admin: 1, moderator: 2) }
  end
end
