User.create!(name: "Admin", email: "adminreal@adm.com", password: "adminadmin", password_confirmation: "adminadmin",
             admin: true)

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 100}@railstutorial.org"
  password = "madurc.29"
  User.create!(name:, email:, password:, password_confirmation: password)
end
