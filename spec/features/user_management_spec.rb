require_relative '../factories/user'

feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = build :user
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, foo@bar.com')
    expect(User.first.email).to eq('foo@bar.com')
  end

  scenario 'requires a matching confirmation password' do
    user = build :baduser
    expect { sign_up(user) }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user = build :baduser
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'only if they provide an email address' do
    user = build :noemailuser
    expect { sign_up(user) }.not_to change(User, :count)
  end

  scenario 'I cannot sign up with an existing email' do
    user = build :user
    user2 = build :user
    sign_up(user)
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end

  def sign_up(user)
    visit '/users/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end
end
