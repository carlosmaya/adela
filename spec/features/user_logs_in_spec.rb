require 'spec_helper'

feature User, 'logs in:' do

  background do
    @user = FactoryGirl.create(:user)
  end

  scenario "fails to access a protected page" do
    visit "/inventories/new"
    sees_error_message "Necesita ingresar o registrarse para continuar."
  end

  scenario "visits root page and sees landing page" do
    visit "/"
    pending "Missing landing page"
  end

  scenario "visits root page and sees log in link" do
    visit "/"
    expect(page).to have_link("Iniciar sesión")
  end

  scenario "sees the log in form" do
    visit "/"
    click_link("Iniciar sesión")
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_css("#user_email")
    expect(page).to have_css("#user_password")
  end

  scenario "fails to log in with an invalid account" do
    visit "/users/sign_in"
    fill_the_form_with(@user.email, "wrong_password")
    click_on("Entrar")
    sees_error_message "Correo o contraseña inválidos."
  end

  scenario "succeed to log in with a valid account" do
    visit "/users/sign_in"
    fill_the_form_with(@user.email, @user.password)
    click_on("Entrar")
    sees_success_message "Bienvenido, el primer paso es crear tu programa de apertura"
    expect(current_path).to eq(topics_path)
  end

  def fill_the_form_with(email, password)
    fill_in("Correo electrónico", :with => email)
    fill_in("Contraseña", :with => password)
  end
end
