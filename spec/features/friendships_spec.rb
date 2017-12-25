require 'rails_helper'

RSpec.feature 'Following friends' do
  before do
    @john = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')
    @sarah = User.create!(first_name: 'Sarah', last_name: 'Joseph', email: 'sarah.joseph@example.com', password: 'password')
    login_as @john
  end

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
