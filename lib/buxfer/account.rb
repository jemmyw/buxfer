module Buxfer
  class Account < OpenStruct
    def self.all
      Buxfer.accounts
    end

    def transactions(options = {})
      Buxfer.transactions(options.merge(:accountId => self.id))
    end
  end
end