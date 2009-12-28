module Buxfer
  class Account < OpenStruct
    def self.all
      Buxfer.accounts
    end

    def transactions(options = {})
      Buxfer.transactions(options.merge(:accountId => self.id))
    end

    def add_transaction(amount, description, status = nil, tags = [])
      Buxfer.add_transaction(amount, description, self.name, status, tags)
    end

    def upload_statement(statement, date_format = 'DD/MM/YYYY')
      Buxfer.upload_statement(self.id, statement, date_format)
    end
  end
end