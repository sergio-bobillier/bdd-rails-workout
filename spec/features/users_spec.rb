require 'rails_helper'

RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.feature 'Users can sign-up on the application' do
  scenario 'A user signs-up with valid credentials' do
    visit '/'

    click_link 'Sign-up'
    expect(page.current_path).to eq(new_user_registration_path)

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page.current_path).to eq(root_path)
    expect(page).to have_content 'You have signed up successfully.'
    expect(page).to have_content 'John Doe'
  end

  scenario 'A user signs-up with invalid credentials' do
    visit '/'

    click_link 'Sign-up'
    expect(page.current_path).to eq(new_user_registration_path)

    fill_in 'First name', with: ''
    fill_in 'Last name', with: ''
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page.current_path).to eq(users_path)
    expect(page).to have_content "First name can't be blank"
    expect(page).to have_content "Last name can't be blank"
  end
end

RSpec.shared_context 'A user already exists' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
  end
end

RSpec.feature 'Users can sign-in into the application' do
  include_context 'A user already exists'

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

RSpec.feature 'Users can sign-out of the application' do
  include_context 'A user already exists'

  before do
    login_as @john
  end

  scenario 'A signed-in user signs-out' do
    visit '/'

    click_link 'Sign-out'
    expect(page.current_path).to eq(root_path)
    expect(page).to have_content 'Signed out successfully.'
  end
end
