module Buxfer
  class Account < OpenStruct
    # Returns an array of accounts. See Buxfer::Base#accounts
    #
    # Example:
    #   Buxfer::Account.all
    #
    def self.all
      Buxfer.accounts
    end

    # Return an array of the last 25 transactions for this account.
    #
    # Valid options:
    #
    # * <tt>:tag</tt> - A Buxfer::Tag object or tag name
    # * <tt>:startDate</tt> - Date in format '10 feb 2008' or '2008-02-10'
    # * <tt>:endDate</tt> - Date in format '10 feb 2008' or '2008-02-10'
    # * <tt>:month</tt> - Month name and year in short format 'feb 08'
    #
    # http://www.buxfer.com/help.php?topic=API#transactions
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

    # Upload a file containing a transaction statement to Buxfer account. The account
    # specified can be a Buxfer::Account (see #accounts) or an account id string.
    #
    # The statement can be a String or an IO object.
    #
    # An optional date format can be passed indicating if the date
    # is 'DD/MM/YYYY' (default) or 'MM/DD/YYYY'
    #
    # Example:
    #
    #   account = Buxfer.accounts.first
    #   Buxfer.upload_statement(account, open('/path/to/file')) => true
    #
    # http://www.buxfer.com/help.php?topic=API#upload_statement
    def upload_statement(statement, date_format = 'DD/MM/YYYY')
      Buxfer.upload_statement(self.id, statement, date_format)
    end
  end
end