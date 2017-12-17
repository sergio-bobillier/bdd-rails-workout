require 'rails_helper'

RSpec.feature 'Home Page' do
  scenario "A user visits the application's home page" do
    visit '/'

    expect(page).to have_link('Athletes Den')
    expect(page).to have_link('Home')
    expect(page).to have_content('Workout Lounge')
  end
end

RSpec.feature 'Members list on the home page' do
  before do
    @members = [
      User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password'),
      User.create!(first_name: 'Sarah', last_name: 'Joseph', email: 'sarah.joseph@example.com', password: 'password')
    ]
  end

  scenario "A user visits the application's home page" do
    visit '/'

    expect(page).to have_content('List of Members')

    @members.each do |member|
      expect(page).to have_content(member.full_name)
    end
  end
end
