require 'rails_helper'

RSpec.feature 'Users can sign-up on the application' do
  scenario 'A user signs-up with valid credentials' do
    visit '/'

    click_link 'Sign-up'
    expect(page.current_path).to eq(new_user_registration_path)

    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page.current_path).to eq(root_path)
    expect(page).to have_content 'You have signed up successfully.'
  end
end

RSpec.feature 'Users can sign-in into the application' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
  end

  scenario 'A user signs-in with valid credentials' do
    visit '/'

    click_link 'Sign-in'
    expect(page.current_path).to eq(new_user_session_path)

    fill_in 'Email', with: @john.email
    fill_in 'Password', with: @john.password
    click_button 'Log in'

    expect(page.current_path).to eq(root_path)
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content "Signed in as #{@john.email}"
  end
end
