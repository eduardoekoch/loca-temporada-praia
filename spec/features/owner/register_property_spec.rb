require 'rails_helper'

feature 'Register Property' do
  scenario 'successfully' do

    realtor = Realtor.create! email: 'realtor@email.com', password: '12345678'
    region = Region.create(name: 'Copacabana')
    property_type = PropertyType.create(name: 'Apartamento')
    
    visit root_path
    click_on 'Entrar como corretor'
    fill_in 'E-mail', with: realtor.email
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'
    click_on 'Cadastrar imóvel'
    fill_in 'Título', with: 'Lindo apartamento 100m da praia'
    fill_in 'Descrição', with: 'Um apartamento excelente para férias'
    select 'Apartamento', from: 'Tipo do imóvel'
    select 'Copacabana', from: 'Região'
    fill_in 'Finalidade do imóvel', with: 'Aluguel de Temporada'
    fill_in 'Área', with: '30'
    fill_in 'Quantidade de cômodos', with: 2
    check 'Possui acessibilidade'
    check 'Aceita animais'
    check 'Aceita fumantes'
    fill_in 'Ocupação máxima', with: 15
    fill_in 'Mínimo de diárias', with: 1
    fill_in 'Máximo de diárias', with: 20
    fill_in 'Valor da diária', with: '500.50'
    attach_file('Inserir foto de destaque', Rails.root.join('spec', 'support', 'casa.jpg'))
    click_on 'Salvar'

    expect(page).to have_css('p', text: 'Imóvel cadastrado com sucesso')
    expect(page).to have_css('h1', text: 'Lindo apartamento 100m da praia')
    expect(page).to have_css('p', text: 'Um apartamento excelente para férias')
    expect(page).to have_css('li', text: region.name)
    expect(page).to have_css('li', text: property_type.name)
    expect(page).to have_css('li', text: 'Aluguel de Temporada')
    expect(page).to have_css('li', text: '30m²')
    expect(page).to have_css('li', text: '2')
    expect(page).to have_css('li', text: 'Possui acessibilidade: Sim')
    expect(page).to have_css('li', text: 'Aceita animais: Sim')
    expect(page).to have_css('li', text: 'Aceita fumantes: Sim')
    expect(page).to have_css('li', text: '15')
    expect(page).to have_css('li', text: '1')
    expect(page).to have_css('li', text: '20')
    expect(page).to have_css('li', text: 'R$ 500.5')
  end

  scenario 'and leave blank fields' do
    realtor = Realtor.create(email: 'realtor@alugatemporada.com', password: '12345678')
    Region.create(name: 'Copacabana')
    PropertyType.create(name: 'Apartamento')
    realtor = Realtor.create! email: 'realtor@email.com', password: '12345678'

    visit root_path
    click_on 'Entrar como corretor'
    fill_in 'E-mail', with: realtor.email
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'
    click_on 'Cadastrar imóvel'
    within 'form' do 
      click_on 'Salvar'
    end
    expect(page).to have_content('Você deve preencher todos os campos')
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Quantidade de cômodos não pode ficar em branco')
    expect(page).to have_content('Ocupação máxima não pode ficar em branco')
    expect(page).to have_content('Mínimo de diárias não pode ficar em branco')
    expect(page).to have_content('Máximo de diárias não pode ficar em branco')
    expect(page).to have_content('Valor da diária não pode ficar em branco')
  end
end
