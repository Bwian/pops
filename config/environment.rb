# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Pops::Application.initialize!

# Common constants
NEW     = 'new'
EDIT    = 'edit'
DELETE  = 'delete'
REFRESH = 'refresh'

ORDERS  = 'orders'
ITEMS   = 'items' 