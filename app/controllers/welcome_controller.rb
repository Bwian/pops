class WelcomeController < ApplicationController
  
  skip_before_filter :authorise, :timeout
  
  EXCLUDE_FORMS = [
    '.',
    '..',
    'items',
    'layouts',
    'sessions',
    'welcome'
  ]
  
  def index
    @forms = []
    Dir.entries('./app/views').each do |fname|
      next if EXCLUDE_FORMS.include?(fname)
      @forms << "#{fname}"    
    end
  end
end
