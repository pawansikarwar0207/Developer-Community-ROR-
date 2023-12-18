# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Change Password', type: :feature do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  scenario 'navigates to the change password page' do
    visit member_path(user)
    click_link 'Change your password', wait: 10
    expect(page).to have_selector('#change-password-form')
  end

  scenario 'shows an error if trying to change password without entering a new password' do
    visit member_path(user)

    click_link 'Change your password', wait: 10

    click_button 'Update'
    sleep 2

    # Expect an error message
    expect(page).to have_text("Password can't be blank")
    sleep 2
  end

  scenario 'changes the password successfully' do
    visit member_path(user)

    click_link 'Change your password', wait: 10

    fill_in 'user_password', with: 'new_password'
    fill_in 'user_password_confirmation', with: 'new_password'

    click_button 'Update'

    expect(page).to have_current_path(member_path(user))
    expect(page).to have_text('You need to sign in or sign up before continuing.')
  end
end
