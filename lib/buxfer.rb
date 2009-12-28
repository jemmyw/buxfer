require 'httparty'
require 'active_support'
require 'ostruct'

OpenStruct.send(:undef_method, :id)
OpenStruct.send(:undef_method, :type)

module Buxfer

end

$: << File.dirname(__FILE__)

require 'buxfer/base'
require 'buxfer/account'
require 'buxfer/tag'