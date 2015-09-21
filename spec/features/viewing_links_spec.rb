require './data_mapper_setup'

feature 'Viewing links' do

    scenario 'I can see existing links on the links page' do
      Link.new(url: 'http://www.makersacademy.com', title: 'Makers Academy')
      visit '/links/new_links'
      fill_in 'url',   with: 'http://www.makersacademy.com'
      fill_in 'title', with: 'Makers Academy'
      click_button 'Create link'
      visit '/links'
      expect(page.status_code).to eq 200
      within 'ul#links' do
        expect(page).to have_content('Makers Academy')
      end
    end
end
