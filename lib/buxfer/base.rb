module Buxfer
  def self.auth(username, password)
    @username = username
    @password = password
    @connection = nil
  end

  def self.username
    @username
  end

  def self.password
    @password
  end

  def self.connection
    @connection ||= Buxfer::Base.new(username, password)
  end

  def self.method_missing(method, *args)
    if connection.respond_to?(method)
      connection.send(method, *args)
    else
      super
    end
  end

  class Base
    include HTTParty
    base_uri 'https://www.buxfer.com/api'
    format :xml

    def initialize(username, password)
      @username = username
      @password = password
    end

    def add_transaction(amount, description, account = nil, status = nil, tags = [])
      amount = (amount < 0 ? amount.to_s : '+' + amount.to_s)
      tags = tags.join(',')
      attrs = {}
      text = [description, amount]

      {:acct => account, :status => status, :tags => tags}.each do |k, v|
        text << '%s:%s' % [k, v] unless v.blank?
      end

      self.class.post('/add_transaction.xml', auth_query({:text => text, :format => 'sms'}, :body))
    end

    def upload_statement(account_id, statement, date_format = 'DD/MM/YYYY')
      unless statement.is_a?(String)
        if statement.respond_to?(:read)
          statement = statement.read
        else
          chec
          statement = statement.to_s
        end
      end

      options = {:accountId => account_id, :statement => statement, :dateFormat => date_format}

      self.class.post('/upload_statement.xml', auth_query(options, :body))
    end

    #noinspection RubyDuckType
    def transactions(options = {})
      get_collection('transactions', options)
    end

    def reports(options = {})
      Buxfer::Report.new(get('/reports.xml', auth_query(options))['response'])
    end

    def accounts
      get_collection 'accounts', :class => Buxfer::Account
    end

    def tags
      get_collection 'tags', :class => Buxfer::Tag
    end

    %w(loans budgets reminders groups contacts).each do |type|
      define_method type do
        get_collection type
      end
    end

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