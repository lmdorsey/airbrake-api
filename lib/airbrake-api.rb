require 'hashie'
require 'httparty'

module AirbrakeAPI
  extend self
  attr_accessor :account, :auth_token, :secure

  class AirbrakeError < StandardError; end

  def configure(options={})
    @account = options[:account] if options.has_key?(:account)
    @auth_token = options[:auth_token] if options.has_key?(:auth_token)
    @secure = options[:secure] if options.has_key?(:secure)
  end

  def account_path
    #"#{protocol}://#{@account}.airbrakeapp.com"
    #"#{protocol}://#{@account}.airbrake.io"
    "#{protocol}://#{@account}.airbrake.io"
  end

  def protocol
    secure ? "https" : "http"
  end

end

require File.join(File.dirname(__FILE__),"airbrake-api/core_extensions.rb")
require File.join(File.dirname(__FILE__),"airbrake-api/client")
require File.join(File.dirname(__FILE__),"airbrake-api/error")
require File.join(File.dirname(__FILE__),"airbrake-api/notice")
require File.join(File.dirname(__FILE__),"airbrake-api/project")
