User.create!(name: "Admin", email: "adminreal@adm.com", password: "adminadmin", password_confirmation: "adminadmin",
             admin: true, activated: true, activated_at: Time.zone.now)

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 4000}@railstutorial.org"
  password = "madurc.29"
  User.create!(name:, email:, password:, password_confirmation: password)
end

users = User.all
user = users.first
following = users[2..32]
followers = users[3..32]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
