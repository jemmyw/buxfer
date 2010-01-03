module Buxfer
  class Account < Buxfer::Response
    # Returns an array of accounts. See Buxfer::Base#accounts
    #
    # Example:
    #   Buxfer::Account.all
    #
    def self.all
      Buxfer.accounts
    end

    # Return an array of the last 25 transactions for this account.
    # See Buxfer::Base#transactions for valid options.
    def transactions(options = {})
      Buxfer.transactions(options.merge(:account => self))
    end

    # Add a transaction to Buxfer. The amount and description must be
    # specified.
    #
    # An array of tag names can be specified.
    #
    # Examples:
    #
    #   account.add_transaction(1000, 'Salary')
    #
    # See: http://www.buxfer.com/help.php?topic=API#add_transaction
    def add_transaction(amount, description, status = nil, tags = [])
      Buxfer.add_transaction(amount, description, self.name, status, tags)
    end

    # Upload a file containing a transaction statement to Buxfer account.
    #
    # The statement can be a String or an IO object.
    #
    # An optional date format can be passed indicating if the dates used in the statement
    # are in the format 'DD/MM/YYYY' (default) or 'MM/DD/YYYY'
    #
    # Example:
    #
    #   account = Buxfer.accounts.first
    #   account.upload_statement(open('/path/to/file')) => true
    #
    # http://www.buxfer.com/help.php?topic=API#upload_statement
    def upload_statement(statement, date_format = 'DD/MM/YYYY')
      Buxfer.upload_statement(self.id, statement, date_format)
    end
  end
end