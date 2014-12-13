# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SALT = 'NaCl'

User.create(
  code: 'admin',
  name: 'Administrator',
  admin: true
)

User.create(
  code: 'guest',
  name: 'Guest',
  admin: false,
  creator: false
)