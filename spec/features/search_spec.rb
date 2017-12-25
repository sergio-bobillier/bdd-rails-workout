require 'rails_helper'

RSpec.feature 'Users search' do
  before do
    @john = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')
    @sarah = User.create!(first_name: 'Sarah', last_name: 'Doe', email: 'sarah.joseph@example.com', password: 'password')
  end

  scenario 'A user search using an existing name' do
    visit '/'
    fill_in 'search_name', with: 'Doe'
    click_button 'Search'

    # TODO: Change this for the corresponding route
    expect(page.current_path).to eq(search_dashboard_path)
    expect(page).to have_content @john.full_name
    expect(page).to have_content @sarah.full_name
  end
end
