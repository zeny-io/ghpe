require 'ghpe'

class Ghpe::Repository
  def self.wrap(client, data)
    data.is_a?(Array) ? data.map { |src| new(client, src) } : new(client, data)
  end

  def initialize(client, src)
    @client = client
    @name = src[:name]
    @permissions = src[:permissions]
  end
  attr_reader :name

  def permission
    if @permissions[:admin]
      :admin
    elsif @permissions[:push]
      :push
    else
      :pull
    end
  end

  def to_dsl
    %(  repository #{@name.inspect}, #{permission.inspect})
  end

  def hash
    name.hash
  end

  def ==(other)
    other.is_a?(Ghpe::Repository) && other.name == name
  end
  alias_method :eql?, :==
end
