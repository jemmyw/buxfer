module Buxfer
  class Tag < OpenStruct
    def transactions(options = {})
      Buxfer.transactions(options.merge(:tagName => self.name))
    end

    def report(options = {})
      Buxfer.reports(options.merge(:tagName => self.name))
    end
  end
end