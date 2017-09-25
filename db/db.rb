# Run this script with `$ ruby my_script.rb`
require 'sqlite3'
require 'active_record'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './db/development.sqlite3'
)


# Define the models
class User < ActiveRecord::Base
  has_many :projects, inverse_of: :user
  has_many :reminders, inverse_of: :user
end

class Project < ActiveRecord::Base
  belongs_to :user, inverse_of: :projects, required: true
end

class Reminder < ActiveRecord::Base
  belongs_to :user, inverse_of: :reminders, required: true
end

# user = User.create!(user_name: 'Name User')
# project1 = user.projects.create!(projects_name: 'bot12', projects_address: 'https234d32sf.com')
