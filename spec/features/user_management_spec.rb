require_relative '../factories/user'
feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = FactoryGirl.create(:user)
    expect { sign_up2(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, foo@bar.com')
    expect(User.first.email).to eq('foo@bar.com')
  end

  scenario 'requires a matching confirmation password' do
    user = FactoryGirl.create(:baduser)
    expect { sign_up2(user) }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user = FactoryGirl.create(:baduser)
    expect { sign_up2(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'only if they provide an email address' do
    user = FactoryGirl.create(:noemailuser)
    expect { sign_up2(user) }.not_to change(User, :count)
  end

  scenario 'I cannot sign up with an existing email' do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    sign_up2(user)
    expect { sign_up2(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end

  def sign_up(email: 'alice@example.com',
            password: '12345678',
            password_confirmation: '12345678')
    visit '/users/new'
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end

  def sign_up2(user)
    visit '/users/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end
end
