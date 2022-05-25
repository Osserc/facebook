# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

first_names = ["Steven", "Mack", "Joanna", "Lot", "Frederick", "Sieglinde", "Oliver", "Winston", "Charles", "Victoria"]
last_names = ["Locking", "Cortas", "Vilnius", "Bet-Beniamin", "Collins", "West", "Crom", "Jill", "David", "Marsh"]
emails = ["user1@proton.com", "user2@proton.com", "user3@proton.com", "user4@proton.com", "user5@proton.com", "user6@proton.com", "user7@proton.com", "user8@proton.com", "user9@proton.com", "user10@proton.com"]

i = 0
emails.each do | mail |
    User.create(first_name: first_names[i], last_name: last_names[i], email: mail, password: "123456")
    i += 1
end