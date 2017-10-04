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

  def sign_up(user_name_slack, channel_name_slack)
    User.create!(user_name_slack: user_name_slack, channel_name_slack: channel_name_slack)
    return user_name_slack
  end

  def db_check_user_sign_up(user_name)
    # binding.pry
    found_user = User.where(user_name_slack: user_name).first
    if found_user == nil
      return 'false' # User not registrarion
    else
      return 'true' # User logs in
    end

  end

end

class Project < ActiveRecord::Base
  belongs_to :user, inverse_of: :projects, required: true
end

class Reminder < ActiveRecord::Base
  belongs_to :user, inverse_of: :reminders, required: true
end

# user = User.create!(user_name: 'Name User')
# project1 = user.projects.create!(projects_name: 'bot12', projects_address: 'https234d32sf.com')

# TO DO
# Save curent user!! working curent user save Project, Reminder
# curent user has many Project adn Reminder
#
#


# user_name_slack = 'U7124GJ917V'
# channel_name_slack = user_name_slack
#
# p User.new.db_check_user_sign_up(user_name_slack)



# p User.new.sign_up(user_name_slack, channel_name_slack)

# p User.new.db_check_user_sign_up(user_name_slack)