# The Buxfer API methods can be called on the Buxfer module after calling
# the #auth method. See Buxfer::Base for more information on each API call.
module Buxfer
  # Specify the authentication details for connecting to Buxfer
  def self.auth(username, password)
    @username = username
    @password = password
    @connection = nil
  end

  def self.method_missing(method, *args) #:nodoc:
    if connection.respond_to?(method)
      connection.send(method, *args)
    else
      super
    end
  end

  private

  # The username that will be used
  def self.username
    @username
  end

  # The password that will be used
  def self.password
    @password
  end

  def self.connection #:nodoc:
    @connection ||= Buxfer::Base.new(username, password)
  end

  public

  # The Buxfer::Base class provides the API methods. It can be instansiated directly
  # or a default instance is used with the Buxfer module.
  #
  # Default usage:
  #
  #   Buxfer.auth('username', 'password')
  #   Buxfer.accounts
  #
  # Instance usage:
  #
  #  client = Buxfer::Base.new('username', 'password')
  #  client.accounts
  #
  class Base
    include HTTParty
    base_uri 'https://www.buxfer.com/api'
    format :xml

    # Create a new Buxfer::Base object with a username and password.
    def initialize(username, password)
      @username = username
      @password = password
    end

    # Add a transaction to Buxfer. The amount and description must be
    # specified.
    #
    # An account name or Buxfer::Account object can be specified
    # if the transaction is to be associated with a particular account.
    #
    # An array of tag names can be specified.
    #
    # Examples:
    #
    #   Buxfer.add_transaction(-10.0, 'Internet bill', 'Current account', nil, %w(bill payment))
    #   Buxfer.add_transaction(1000, 'Salary', 'Current account', 'pending', %w(salary))
    #
    # See: http://www.buxfer.com/help.php?topic=API#add_transaction
    def add_transaction(amount, description, account = nil, status = nil, tags = [])
      amount = (amount < 0 ? amount.to_s : '+' + amount.to_s)
      tags = tags.join(',')
      attrs = {}
      text = [description, amount]
      account.respond_to?(:name) ? account.name : account.to_s

      {:acct => account, :status => status, :tags => tags}.each do |k, v|
        text << '%s:%s' % [k, v] unless v.blank?
      end

      self.class.post('/add_transaction.xml', auth_query({:text => text, :format => 'sms'}, :body))
    end

    # Upload a file containing a transaction statement to Buxfer account. The account
    # specified can be a Buxfer::Account (see #accounts) or an account id string.
    #
    # The statement can be a String or an IO object.
    #
    # An optional date format can be passed indicating if the dates used in the statement
    # are in the format 'DD/MM/YYYY' (default) or 'MM/DD/YYYY'
    #
    # Example:
    #
    #   account = Buxfer.accounts.first
    #   Buxfer.upload_statement(account, open('/path/to/file')) => true
    #
    # http://www.buxfer.com/help.php?topic=API#upload_statement
    def upload_statement(account, statement, date_format = 'DD/MM/YYYY')
      account_id = account.is_a?(Buxfer::Account) ? account.id : account
      
      unless statement.is_a?(String)
        if statement.respond_to?(:read)
          statement = statement.read
        else
          statement = statement.to_s
        end
      end

      options = {:accountId => account_id, :statement => statement, :dateFormat => date_format}

      self.class.post('/upload_statement.xml', auth_query(options, :body))
    end

    # Return an array of the last 25 transactions.
    #
    # Valid options:
    #
    # * <tt>:account</tt> - A Buxfer::Account or account name
    # * <tt>:tag</tt> - A Buxfer::Tag object or tag name
    # * <tt>:startDate</tt> - Date in format '10 feb 2008' or '2008-02-10'
    # * <tt>:endDate</tt> - Date in format '10 feb 2008' or '2008-02-10'
    # * <tt>:month</tt> - Month name and year in short format 'feb 08'
    #
    # http://www.buxfer.com/help.php?topic=API#transactions
    def transactions(options = {})
      options.symbolize_keys!

      if account = options.delete(:account)
        options[:accountName] = account.is_a?(Buxfer::Account) ? account.name : account
      end

      if tag = options.delete(:tag)
        options[:tagName] = tag.is_a?(Buxfer::Tag) ? tag.name : tag
      end

      get_collection('transactions', options)
    end

    # Return a Buxfer::Report object.
    #
    # http://www.buxfer.com/help.php?topic=API#reports
    def reports(options = {})
      Buxfer::Report.new(get('/reports.xml', auth_query(options))['response'])
    end

    # Returns an array of Buxfer::Account objects
    #
    # http://www.buxfer.com/help.php?topic=API#accounts
    def accounts
      get_collection 'accounts', :class => Buxfer::Account
    end

    # Returns an array of Buxfer::Tag objects
    #
    # http://www.buxfer.com/help.php?topic=API#tags
    def tags
      get_collection 'tags', :class => Buxfer::Tag
    end

    # http://www.buxfer.com/help.php?topic=API#loans
    def loans;     get_collection('loans');     end
    # http://www.buxfer.com/help.php?topic=API#budgets
    def budgets;   get_collection('budgets');   end
    # http://www.buxfer.com/help.php?topic=API#reminders
    def reminders; get_collection('reminders'); end
    # http://www.buxfer.com/help.php?topic=API#groups
    def groups;    get_collection('groups');    end
    # http://www.buxfer.com/help.php?topic=API#contacts
    def contacts;  get_collection('contacts');  end

    private

    def get(*args)
      self.class.get(*args)
    end

    def get_collection(plural, options = {})
      options.symbolize_keys!
      path = options.delete(:path) || '/%s.xml' % plural
      singular = options.delete(:singular) || plural.singularize
      klass = options.delete(:class) || Buxfer::Response

      response = get(path, auth_query(options))['response']
      load_collection(response[plural][singular], klass)
    end

    def load_collection(collection, klass = Buxfer::Response)
      if collection.respond_to?(:map)
        collection.map{|item| klass.new(item) }
      else
        [klass.new(collection)]
      end
    end

    def auth
      @auth ||= begin
        self.class.get('/login.xml', :query => {:userid => @username, :password => @password})
      end
    end

    def token
      auth['response']['token']
    end

    def auth_query(options = {}, container = :query)
      {container => options.merge(:token => token)}
    end
  end
end