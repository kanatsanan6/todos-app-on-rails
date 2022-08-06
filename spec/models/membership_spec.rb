# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'valid factory' do
    subject { build(:membership) }

    it { is_expected.to be_valid }
  end

  describe 'validations and associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:user) }
  end
end
