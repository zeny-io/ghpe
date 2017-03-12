require 'ghpe/dsl'

class Ghpe::DSL::Team
  def initialize(name, &block)
    @name = name
    @privacy = :closed
    @description = nil
    @members = []
    @repositories = []

    instance_eval(&block)
  end

  def privacy(val)
    @privacy = val.to_s.to_sym
  end

  def to_permissions(p)
    case p.to_s.to_sym
    when :admin
      { admin: true }
    when :push
      { push: true }
    when :pull
      { pull: true }
    else
      {}
    end
  end

  def description(val)
    @description = val
  end

  def member(login)
    @members.push(login)
  end

  def repository(name, permission)
    @repositories.push(name: name, permission: permission)
  end

  def transform(client)
    Ghpe::Team.new(
      client,
      name: @name,
      privacy: @privacy,
      description: @description,
      members: @members,
      repositories: @repositories.map do |repo|
        Ghpe::Repository.new(
          client,
          name: repo[:name],
          permissions: to_permissions(repo[:permission])
        )
      end
    )
  end
end
