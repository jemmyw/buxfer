require 'httparty'
require 'active_support'

class Buxfer
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

  def upload_statement(accountId, statement, dateFormat = 'DD/MM/YYYY')
    unless statement.is_a?(String)
      if statement.respond_to?(:read)
        statement = statement.read
      else chec
        statement = statement.to_s
      end
    end

    options = {:accountId => accountId, :statement => statement, :dateFormat => dateFormat}

    self.class.post('/upload_statement.xml', auth_query(options, :body))
  end

  def transactions(options = {})
    self.class.get('/transactions.xml', auth_query(options))['response']['transactions']['transaction']
  end
  
  def reports(options = {})
    self.class.get('/reports.xml', auth_query(options))['response']['reports']['report']
  end

  def accounts
    self.class.get('/accounts.xml', auth_query)['response']['accounts']['account']
  end

  def loans
    self.class.get('/loans.xml', auth_query)['response']['loans']['loan']
  end

  def tags
    self.class.get('/tags.xml', auth_query)['response']['tags']['tag']
  end

  private

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