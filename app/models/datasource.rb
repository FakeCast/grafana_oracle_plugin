class Datasource < ActiveRecord::Base
    def self.element_to_hash
      element = {
          :metric => self.split("|")[0],
          :id => self.split("|")[1]
      }
      return element
    end
end
