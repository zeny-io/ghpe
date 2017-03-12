require 'octokit'
require 'ghpe'

class Ghpe::Client
  USER_AGENT = "ghpe(v#{Ghpe::VERSION}): github permission management tool".freeze

  def initialize(options)
    @octokit = Octokit::Client.new(access_token: options[:api_token], user_agent: USER_AGENT)
    @org = options[:organization]

    octokit.middleware.tap do |faraday|
      faraday.response(:logger) if options[:debug]
    end
  end
  attr_reader :octokit, :org

  protected

  def respond_to_missing?(name, include_all)
    super || octokit.respond_to?(name, include_all)
  end

  def method_missing(name, *args, &block)
    if octokit.respond_to?(name)
      octokit.send(name, *args, &block)
    else
      super
    end
  end
end
