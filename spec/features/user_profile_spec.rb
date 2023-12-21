# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Profile', type: :feature do
  describe 'User Profile' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the root path page' do
      find('#add-user-profile-link', wait: 10).click
      sleep 2
    end

    it 'should open the member connection page' do
      visit member_path(user)
      sleep 2
    end
  end
end
