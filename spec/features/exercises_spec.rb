require 'rails_helper'

RSpec.shared_context 'A user is logged-in' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    login_as @john
  end
end

RSpec.feature 'Users can create exercises' do
  include_context 'A user is logged-in'

  scenario 'The user creates an exercise with valid imputs' do
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

  scenario 'The user tries to create an exercise with invalid inputs' do
    visit '/'

    click_link 'My Lounge'
    click_link 'New Workout'

    fill_in 'Duration', with: nil
    fill_in 'Workout details', with: ''
    fill_in 'Activity date', with: ''
    click_button 'Save'

    expect(page).to have_content 'Exercise has not been created'
    expect(page).to have_content "Duration in min can't be blank"
    expect(page).to have_content "Duration in min is not a number"
    expect(page).to have_content "Workout can't be blank"
    expect(page).to have_content "Workout date can't be blank"
  end
end

RSpec.feature 'Users can list their exercises' do
  include_context 'A user is logged-in'

  before do
    @exercises = [
      @john.exercises.create(duration_in_min: 20, workout: 'Body building routine', workout_date: '2017-12-09'),
      @john.exercises.create(duration_in_min: 20, workout: 'Cardio', workout_date: '2017-12-10')
    ]
  end

  scenario "The user click 'My Lounge' link to see it's exercises list" do
    visit '/'

    click_link 'My Lounge'

    @exercises.each do |exercise|
      expect(page).to have_content exercise.duration_in_min
      expect(page).to have_content exercise.workout
      expect(page).to have_content exercise.workout_date
    end
  end
end
