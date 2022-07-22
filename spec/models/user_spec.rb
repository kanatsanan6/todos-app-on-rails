# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid factory' do
    subject { build(:user) }

    it { is_expected.to be_valid }
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to have_many(:comments) }
  end
end
