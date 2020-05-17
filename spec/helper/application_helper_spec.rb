require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe 'full title' do
    it 'have the right title in index' do
      expect(full_title('')).to eq 'Nature-Picture'
    end

    it 'have the right title when title is nil' do
      expect(full_title(nil)).to eq 'Nature-Picture'
    end

    it 'have the right title when title is hoge' do
      expect(full_title("hoge")).to eq("hoge - Nature-Picture")
    end
  end
end
