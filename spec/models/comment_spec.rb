# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'valid factory' do
    subject { build(:comment) }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :commenter }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to belong_to(:task) }
  end
end
