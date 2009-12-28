module Buxfer
  class Tag < OpenStruct
    # Return an array of the last 25 transactions for this tag.
    # See Buxfer::Base#transactions for valid options.
    def transactions(options = {})
      Buxfer.transactions(options.merge(:tag => self))
    end

    def report(options = {})
      Buxfer.reports(options.merge(:tagName => self.name))
    end
  end
end