# Run this script with `$ ruby my_script.rb`
require 'sqlite3'
require 'active_record'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './db/development.sqlite3',
    pool: 25)

# Define the models
class User < ActiveRecord::Base
  has_many :projects, inverse_of: :user
  has_many :reminders, inverse_of: :user

  def sign_up(user_name_slack, channel_name_slack)
    User.create!(user_name_slack: user_name_slack, channel_name_slack: channel_name_slack)
    user_name_slack
  end

  def db_check_user_sign_up(user_name_slack)
    found_user = User.where(user_name_slack: user_name_slack).first
    if found_user == nil
      'false' # User not registrarion
    else
      'true' # User logs in
    end
  end
end

class Project < ActiveRecord::Base
  belongs_to :user, inverse_of: :projects, required: true

  def user_add_project (user_name_slack, projects_url_jenkins, projects_url_slack, projects_name, project_way)
    user = User.where(user_name_slack: user_name_slack).first
    user.projects.create!(projects_url_jenkins: projects_url_jenkins,
                          projects_url_slack: projects_url_slack,
                          projects_name: projects_name,
                          project_way: project_way)
  end

  def search_way_project(project_name, user_name_slack)
    # user = User.where(user_name_slack: user_name_slack).first
    # user.projects.find_by(projects_name: project_name)["project_way"]
    Project.where(projects_name: project_name).first["project_way"]
  end

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
# user_name_slack = 'U7124GJ917V'
# channel_name_slack = user_name_slack
#
# p User.new.db_check_user_sign_up(user_name_slack)

# p User.new.sign_up(user_name_slack, channel_name_slack)
# p User.new.db_check_user_sign_up(user_name_slack)


# user_name = 'U74GJ917V'
# name_project = 'MyBot'
#
# Project.new.user_add_project(user_name, name_project)
