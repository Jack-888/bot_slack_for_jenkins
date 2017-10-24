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
  create_table :users, force: true do |t|
    t.string :user_name_slack #'U74GJ917V'
    t.string :channel_name_slack
  end

  create_table :projects, force: true do |t|
    t.string :projects_name # OnlineShopJSFinal
    t.string :projects_url_jenkins # "http://jenkins.andersenlab.com/job/DevopsTest/job/online-shopJSFinal/"
    t.string :projects_url_slack # "\"http://jenkins.andersenlab.com/job/DevopsTest/job/online-shopJSFinal\""
    t.string :projects_url_monitoring # \"http://jenkins.andersenlab.com/job/DevopsTest/job/online-shopJSFinal\"

    # RF Rename project way in project path
    t.string :project_way # "MyProject and way DevopsTest/job/GradleUnitTest"


    t.integer :user_id
    t.belongs_to :user, index: true
  end

  create_table :reminders, force: true do |t|
    t.string :user_name_slack #'U74GJ917V'
    t.string :name_user_for_reminder #'U74GJ917V'
    t.string :reminder_text # 'some text'
    t.datetime :reminder_time_chronic  # format time => '2017-10-20 10:32:00 +0300'
    t.string :reminder_time # input user => "at today 16:38"
    t.string :jid # Sidekiq job id => "b849048c5675f1b99e668644"


    t.integer :user_id
    t.belongs_to :user, index: true
  end
end