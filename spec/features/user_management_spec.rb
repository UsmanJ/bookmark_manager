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

  feature 'User sign in' do
    let(:user) do
      User.create(email: 'user@example.com',
                  password: 'secret1234',
                  password_confirmation: 'secret1234')
    end

    scenario 'with correct credentials' do
      sign_in(email: user.email,   password: user.password)
      expect(page).to have_content "Welcome, #{user.email}"
    end

    it 'does not authenticate when given an incorrect password' do
      expect(User.authenticate(user.email, 'wrong_stupid_password')).to be_nil
    end
  end

  feature 'User signs out' do
    let(:user) do
      User.create(email: 'usman@test.com',
                  password: 'secret1234',
                  password_confirmation: 'secret1234')
    end

    scenario 'while being signed in' do
      sign_in(email: user.email,   password: user.password)
      click_button 'Sign out'
      expect(page).to have_content('goodbye!') # where does this message go?
      expect(page).not_to have_content('Welcome, usman@test.com')
    end
  end

  feature 'Password reset' do

   scenario 'requesting a password reset' do
   user = User.create(email: 'test@test.com', password: 'secret1234',
                      password_confirmation: 'secret1234')
     visit '/password_reset'
     fill_in 'Email', with: user.email
     click_button 'Reset password'
     user = User.first(email: user.email)
     expect(user.password_token).not_to be_nil
     expect(page).to have_content 'Check your emails'
   end
  end

  scenario 'resetting password' do
  user = User.create(email: 'test@test.com', password: 'secret1234',
                     password_confirmation: 'secret1234')
   user = User.first(email: 'test@test.com')
   user.password_token = 'token'
   user.save

   visit "/users/password_reset/#{user.password_token}"
   expect(page.status_code).to eq 200
   expect(page).to have_content 'Enter a new password'
 end
end
