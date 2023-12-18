# spec/requests/events_spec.rb
require 'rails_helper'

RSpec.feature 'Events', type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event, user: user) }

  scenario 'user can view events index' do
    get events_path
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:index)
  end

  scenario 'user can view new event form' do
    sign_in user
    get new_event_path
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:new)
  end

  scenario 'user can create a new event' do
    sign_in user
    post events_path, params: { event: attributes_for(:event) }
    expect(response).to have_http_status(:created)
  end

  scenario 'user sees errors if event creation fails' do
    sign_in user
    post events_path, params: { event: { invalid: 'data' } }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  scenario 'user can view the edit form for an event' do
    sign_in user
    get edit_event_path(event)
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:edit)
  end

  scenario 'user can update an event' do
    sign_in user
    put event_path(event), params: { event: { event_name: 'Updated Event' } }
    expect(response).to redirect_to(events_path)
    follow_redirect!
    expect(response.body).to include('Event was successfully updated.')
  end

  scenario 'user sees errors if event update fails' do
    sign_in user
    put event_path(event), params: { event: { event_name: '' } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response).to render_template(:edit)
  end

  scenario 'user can view a specific event' do
    get event_path(event)
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:show)
  end

  scenario 'user can delete an event' do
    sign_in user
    delete event_path(event)
    expect(response).to redirect_to(events_path)
  end

  scenario 'user can view the calendar' do
    get calendar_events_path
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:calendar)
  end

  scenario 'user can create a new calendar event' do
    sign_in user
    post calendar_events_path, params: { event: attributes_for(:event) }
    expect(response).to have_http_status(:created)
  end

  scenario 'user sees errors if calendar event creation fails' do
    sign_in user
    post calendar_events_path, params: { event: { invalid: 'data' } }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
