module Buxfer
  class Tag < OpenStruct
    # Return an array of the last 25 transactions for this tag
    #
    # Valid options:
    #
    # * <tt>:account</tt> - A Buxfer::Account or account name
    # * <tt>:startDate</tt> - Date in format '10 feb 2008' or '2008-02-10'
    # * <tt>:endDate</tt> - Date in format '10 feb 2008' or '2008-02-10'
    # * <tt>:month</tt> - Month name and year in short format 'feb 08'
    #
    # http://www.buxfer.com/help.php?topic=API#transactions
    def transactions(options = {})
      Buxfer.transactions(options.merge(:tag => self))
    end

    def report(options = {})
      Buxfer.reports(options.merge(:tagName => self.name))
    end
  end
end