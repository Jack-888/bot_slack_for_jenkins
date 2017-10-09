# Run this script with `$ ruby my_script.rb`
require 'sqlite3'
require 'active_record'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: './db/development.sqlite3',
    pool: 25
)

# Define a minimal database schema
ActiveRecord::Schema.define do
  # create_table :shows, force: true do |t|
  #   t.string :name
  # end
  #
  # create_table :episodes, force: true do |t|
  #   t.string :name
  #   t.belongs_to :show, index: true
  # end

  create_table :users, force: true do |t|
    t.string :user_name_slack #'U74GJ917V'
    t.string :channel_name_slack
  end

  create_table :projects, force: true do |t|
    t.string :projects_name # OnlineShopJSFinal
    t.string :projects_url_jenkins # "http://jenkins.andersenlab.com/job/DevopsTest/job/online-shopJSFinal/"
    t.string :projects_url_slack # "\"http://jenkins.andersenlab.com/job/DevopsTest/job/online-shopJSFinal\""
    t.string :project_way # "MyProject and way DevopsTest/job/GradleUnitTest"


        t.integer :user_id
    t.belongs_to :user, index: true
  end

  create_table :reminders, force: true do |t|
    t.string :reminders_text
    t.datetime :reminders_time
    t.integer :amount_days

    t.integer :user_id
    t.belongs_to :user, index: true
  end

end