# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'valid factory' do
    subject { build(:task) }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(5).on(:create) }
    it { should define_enum_for(:status).with_values(pending: 0, in_progress: 1, done: 2) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to belong_to(:user) }
    it { should define_enum_for(:scope).with_values(scope_public: 0, scope_private: 1) }
  end
end
