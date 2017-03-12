require 'ghpe'

class Ghpe::Team
  PRIVACIES = [%w(secret closed)].freeze
  PERMISSIONS = [%w(pull push admin)].freeze

  def self.wrap(client, data)
    data.respond_to?(:map) ? data.map { |src| new(client, src) } : new(client, data)
  end

  def initialize(client, src)
    @client = client
    @name = src[:name]
    @id = src[:id]
    @slug = src[:slug]
    @description = src[:description]
    @privacy = src[:privacy].to_s.to_sym

    @members = src[:members]
    @repositories = src[:repositories]
  end
  attr_reader :name, :id, :description, :privacy

  def members
    @members ||= @client.team_members(@id).map(&:login)
  end

  def repositories
    @repositories ||= Ghpe::Repository.wrap(@client, @client.team_repositories(@id))
  end

  def attributes
    {
      description: @description,
      privacy: @privacy
    }
  end

  def to_dsl
    [
      %(team "#{@name}" do),
      %(  privacy ) + @privacy.inspect,
      %(  description ) + (@description.nil? ? 'nil' : @description.inspect),
      '',
      members.map { |member| %(  member "#{member}") }.join("\n"),
      '',
      repositories.map(&:to_dsl).join("\n"),
      %(end)
    ].join("\n").gsub(/\n{2,}end/, "\nend")
  end

  def hash
    name.hash
  end

  def ==(other)
    other.is_a?(Ghpe::Team) && other.name == name
  end
  alias_method :eql?, :==
end
