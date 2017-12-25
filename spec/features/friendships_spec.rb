require 'rails_helper'

RSpec.shared_context 'A pair of users exist and one of them is logged-in' do
  before do
    @john = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')
    @sarah = User.create!(first_name: 'Sarah', last_name: 'Joseph', email: 'sarah.joseph@example.com', password: 'password')
    login_as @john
  end
end

RSpec.shared_context 'One of the users is following the other' do
  before do
    Friendship.create(user: @john, friend: @sarah)
  end
end

RSpec.feature 'Following friends' do
  include_context 'A pair of users exist and one of them is logged-in'

  scenario 'A signed-in user visits the home page and follows another user' do
    visit '/'

    expect(page).to have_content @john.full_name
    expect(page).to have_content @sarah.full_name

    # A user can't follow himself.
    expect(page).not_to have_link 'Follow', href: "#{friendships_path(friend_id: @john.id)}"

    # A user can follow other users.
    link = "a[href='#{friendships_path(friend_id: @sarah.id)}']"
    find(link).click

    # A user can't cannot follow a user he is already following.
    expect(page).not_to have_link 'Follow', href: "#{friendships_path(friend_id: @sarah.id)}"
  end
end

RSpec.feature 'Show followed friends' do
  include_context 'A pair of users exist and one of them is logged-in'
  include_context 'One of the users is following the other'

  scenario 'A user visits the "My Lounge" page and sees a list of his friends' do
    visit '/'
    click_link 'My Lounge'

    expect(page).to have_content 'My friends'
    expect(page).to have_link @sarah.full_name
    expect(page).to have_link 'Unfollow'
  end
end

RSpec.feature "Show a friend's workout" do
  include_context 'A pair of users exist and one of them is logged-in'
  include_context 'One of the users is following the other'

  before do
    @ex1 = @sarah.exercises.create(duration_in_min: 74, workout: 'Weight lifting routine', workout_date: Date.today - 1.day)
    @ex2 = @sarah.exercises.create(duration_in_min: 55, workout: 'Weight lifting routine', workout_date: Date.today)
  end

  scenario "A user sees a friend's workout" do
    visit '/'

    click_link 'My Lounge'
    click_link @sarah.full_name

    expect(page.current_path).to eq friendship_path(@john.current_friendship(@sarah))
    expect(page).to have_content @ex2.workout
    expect(page).to have_css 'div#chart'
  end
end
