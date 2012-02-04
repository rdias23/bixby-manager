# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "agents", :force => true do |t|
    t.integer  "host_id",                                      :null => false
    t.string   "uuid"
    t.string   "ip",         :limit => 16
    t.integer  "port",       :limit => 2,   :default => 18000
    t.string   "public_key", :limit => 426
    t.integer  "status",     :limit => 2,   :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["host_id"], :name => "fk_agents_hosts1"
  add_index "agents", ["id"], :name => "id_UNIQUE", :unique => true

  create_table "checks", :force => true do |t|
    t.integer "service_id",                                      :null => false
    t.integer "agent_id",                                        :null => false
    t.integer "command_id",                                      :null => false
    t.string  "args"
    t.integer "normal_interval", :limit => 2
    t.integer "retry_interval",  :limit => 2
    t.boolean "plot"
    t.boolean "enabled",                      :default => false
  end

  add_index "checks", ["agent_id"], :name => "fk_checks_agents1"
  add_index "checks", ["command_id"], :name => "fk_checks_commands1"
  add_index "checks", ["service_id"], :name => "fk_checks_services1"

  create_table "commands", :force => true do |t|
    t.integer "org_id",  :null => false
    t.string  "repo"
    t.string  "bundle"
    t.string  "command"
  end

  add_index "commands", ["org_id"], :name => "fk_commands_orgs1"

  create_table "hosts", :force => true do |t|
    t.integer "org_id",                 :null => false
    t.string  "ip",       :limit => 16
    t.string  "hostname"
    t.string  "alias"
    t.string  "desc"
  end

  add_index "hosts", ["org_id"], :name => "fk_hosts_orgs1"

  create_table "orgs", :force => true do |t|
    t.integer "tenant_id"
    t.string  "name"
  end

  add_index "orgs", ["id"], :name => "id_UNIQUE", :unique => true
  add_index "orgs", ["tenant_id"], :name => "fk_orgs_tenants1"

  create_table "services", :force => true do |t|
    t.integer "host_id", :null => false
    t.string  "name"
  end

  add_index "services", ["host_id"], :name => "fk_services_hosts1"

  create_table "tenants", :force => true do |t|
    t.string "name"
    t.string "password", :limit => 32, :null => false
  end

  create_table "users", :force => true do |t|
    t.integer "org_id",   :null => false
    t.string  "username", :null => false
    t.string  "name"
    t.string  "email"
  end

  add_index "users", ["org_id"], :name => "fk_users_orgs1"

end