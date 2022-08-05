# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'valid factory' do
    subject { build(:company) } 

    it { is_expected.to be_valid }
  end
end

