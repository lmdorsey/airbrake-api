module AirbrakeAPI
  class Base
    include HTTParty
    format :xml

    private

    def self.setup
      base_uri AirbrakeAPI.account_path
      default_params :auth_token => AirbrakeAPI.auth_token

      check_configuration
    end

    def self.check_configuration
      raise AirbrakeError.new('API Token cannot be nil') if default_options.nil? || default_options[:default_params].nil? || !default_options[:default_params].has_key?(:auth_token)
      raise AirbrakeError.new('Account cannot be nil') unless default_options.has_key?(:base_uri)
    end

    def self.fetch(path, options)
      response = get(path, { :query => options })
      if response.code == 403
        raise AirbrakeError.new('SSL should be enabled - use AirbrakeAPI.secure = true in configuration')
      end

      Hashie::Mash.new(response)
    end

  end
end

# airbrake sometimes returns broken xml with invalid xml tag names
# so we remove them
require 'httparty/parser'
class HTTParty::Parser
  def xml
    body.gsub!(/<__utmz>.*?<\/__utmz>/m,'')
    body.gsub!(/<[0-9]+.*?>.*?<\/[0-9]+.*?>/m,'')
    body.gsub!(/<\|>.*?<\/\|>/m, '')
    body.gsub!("<br>", "<br/>")
    body.gsub!("&larr;", "&lt;")
    body.gsub!("&rarr;", "&gt;")
    body.gsub!("&copy;", "(c)")
    # # something wacky with Airbrake (quelle surprise -- but this only delays the fatal error)
    body.gsub!('<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">', '<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1"/>')
    #body.gsub!("<title>Application Error</title></head>", "<title>Application Error</title>")
    #body.gsub!("scr\"\+\"i", "scri")
    #body.gsub!(/<script.*<\/script>/m, "")
    #puts " >> #{body}"
    # rescue MultiXml::ParseError
    # return nil
    #begin 
      MultiXml.parse(body)
    #rescue MultiXml::ParseError => e
    #  puts " >> #{e.inspect}"
    #  puts " >> #{body}"
    #end

    # body.gsub!(/<__utmz>.*?<\/__utmz>/m,'')
    # body.gsub!(/<[0-9]+.*?>.*?<\/[0-9]+.*?>/m,'')
    # MultiXml.parse(body)
  end
end
