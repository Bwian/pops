module ActiveRecord
  class Base
    # This is overridden for view helpers which need something other than a standard model name for their link descriptions
    def self.pops_name
      self.name  
    end
  end
end