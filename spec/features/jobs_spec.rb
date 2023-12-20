# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Jobs', type: :feature do
  describe 'Jobs' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should have My Jobs text on root path' do
      find('#my-job', wait: 10).click
      expect(page).to have_text('Create Job', wait: 10)
    end

    # it 'should open the job form and display the validation errors if empty form is submitted' do

    #   find('#add-job-link', wait: 10).click
    #   expect(page).to have_text('Create Job', wait: 10)

    #   click_button 'Create Job'

    #   expect(page).to have_text('9 errors prohibited your jobs form being saved.')
    #   expect(page).to have_text("Title can't be blank")
    #   expect(page).to have_text("Content can't be blank")
    # end

    it 'should open the job form and save to db if all validation passed' do

      job_category = create(:job_category)

      marketing_agency_page = create(:page, title: 'Marketing Agency X', user: user)

      visit user_my_jobs_path(user)
      
      find('#add-job-link', wait: 10).click
      
      expect(page).to have_text('Create Job', wait: 10)

      fill_in 'job_title', with: 'Software Engineer'
      fill_in 'job_description', with: 'Exciting opportunity for software engineer.'
      select 'Full-time', from: 'job_employee_type'
      fill_in 'job_location', with: 'San Francisco'
      select '₹ 15000-20000', from: 'job_salary'
      select job_category.name, from: 'job_job_category_id'
      select 'Graduation', from: 'job_qualification'
      select 'Public', from: 'job_status'
      select marketing_agency_page.title, from: 'job_page_id'
      sleep 2

      click_button 'Create Job'

      visit jobs_path
      expect(page).to have_text('Software Engineer')
      expect(page).to have_text('Exciting opportunity for')
      expect(page).to have_text('San Francisco')
      expect(page).to have_text('₹ 15000-20000')
      expect(page).to have_text('Full-time')
      expect(page).to have_text(job_category.name)
    end
  end
end
