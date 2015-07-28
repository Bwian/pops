# Load the Rails application.
require File.expand_path('../application', __FILE__)

CONFIG_FILE = File.expand_path('../application.yml', __FILE__)

# Initialize the Rails application.
Pops::Application.initialize!

begin
  envs = YAML.load_file(CONFIG_FILE)[Rails.env]
rescue
  Rails.logger.error "Error loading configuration file #{CONFIG_FILE}"
  envs = {}
end

envs.each do |key,value|
  ENV[key] = value.to_s
end

# Common constants
NEW     = 'new'
EDIT    = 'edit'
DELETE  = 'delete'
REFRESH = 'refresh'
PRINT   = 'print'

ORDERS  = 'orders'
ITEMS   = 'items' 