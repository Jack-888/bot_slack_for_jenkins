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
    t.string :user_name
  end

  create_table :projects, force: true do |t|
    t.string :projects_name
    t.string :projects_address
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