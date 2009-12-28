module Buxfer
  class Tag < OpenStruct

    def transactions(options = {})
      Buxfer.transactions(options.merge(:tagName => self.name))
    end

  end
end