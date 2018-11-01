# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

depth = 5; width = 5
parents = []; children = []

Comment.delete_all

(depth-1).times do
  if parents.empty?
    width.times do
      parents << Comment.create!(body: Faker::Matz.quote)
    end
  end

  parents.each do |parent|
    width.times do
      children << parent.children.create!(body: Faker::Matz.quote)
    end
  end

  parents = children
  children = []
end
