require 'httparty'
require 'active_support'
require 'ostruct'

module Buxfer
  class Response < OpenStruct
    undef_method :id
    undef_method :type
  end
end

$: << File.dirname(__FILE__)

require 'buxfer/base'
require 'buxfer/account'
require 'buxfer/tag'
require 'buxfer/report'