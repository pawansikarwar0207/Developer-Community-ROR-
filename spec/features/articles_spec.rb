# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Articles', type: :feature do
  describe 'Articles' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the article form and display the validation errors if empty form is submitted' do

      find('#add-article-link', wait: 10).click
      expect(page).to have_text('Write Article', wait: 10)

      click_button 'Submit'

      expect(page).to have_text('2 errors prohibited your articles form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Content can't be blank")
    end

    it 'should open the article form and save to db if all validation passed' do
      
      find('#add-article-link', wait: 10).click
      
      expect(page).to have_text('Write Article', wait: 10)

      fill_in 'article_title', with: 'Sample Article'
      fill_in 'article_content', with: 'This is a sample article content.'

      click_button 'Submit'

      visit articles_path
      expect(page).to have_text('Sample Article')
      expect(page).to have_text('This is a sample article content.')
    end
  end
end
