require 'rails_helper'

RSpec.feature 'Users can create exercises' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    login_as @john
  end

  scenario 'A user creates an exercise with valid imputs' do
    visit '/'

    click_link 'My Lounge'
    click_link 'New Workout'
    expect(page).to have_link 'Back'

    fill_in 'Duration', with: 70
    fill_in 'Workout details', with: 'Weight lifting'
    fill_in 'Activity date', with: '2017-12-10'
    click_button 'Save'

    expect(page).to have_content 'Exercise has been created'
    expect(page.current_path).to eq(user_exercise_path(@john, Exercise.last))
  end
end
