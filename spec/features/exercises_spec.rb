require 'rails_helper'

RSpec.shared_context 'A user is logged-in' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    login_as @john
  end
end

RSpec.shared_context 'The user has exercises' do
  before do
    @exercises = [
      @john.exercises.create!(duration_in_min: 45, workout: 'Body building routine', workout_date: Date.today - 3.days),
      @john.exercises.create!(duration_in_min: 35, workout: 'Cardio', workout_date: Date.today)
    ]
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
    fill_in 'Activity date', with: Date.today
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
  include_context 'The user has exercises'

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

RSpec.feature 'Users can edit existing exercises' do
  include_context 'A user is logged-in'
  include_context 'The user has exercises'

  scenario 'The user tries to edit an exercise with valid inputs' do
    visit '/'

    click_link 'My Lounge'
    find("a[href='#{edit_user_exercise_path(@john, @exercises.first)}']").click

    fill_in 'Duration', with: 50
    click_button 'Save'

    expect(page.current_path).to eq (user_exercise_path(@john, @exercises.first))
    expect(page).to have_content('Exercise has been updated')
    expect(page).to have_content('50')
    expect(page).not_to have_content(@exercises.first.duration_in_min)
  end
end

RSpec.feature 'Users can delete exercises' do
  include_context 'A user is logged-in'
  include_context 'The user has exercises'

  scenario 'The user tries to delete an exercise' do
    visit '/'

    click_link 'My Lounge'
    find("a[href='#{user_exercise_path(@john, @exercises.first)}'][data-method=delete]").click

    expect(page.current_path).to eq(user_exercises_path(@john))
    expect(page).to have_content('Exercise has been deleted')
  end
end
