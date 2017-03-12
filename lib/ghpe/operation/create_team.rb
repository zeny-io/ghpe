require 'ghpe/operation'

class Ghpe::Operation::CreateTeam
  def initialize(team)
    @team = team
  end

  def display(shell)
    shell.say("+   Create team: #{@team.name}", :green)
    @team.attributes.each_pair do |k, v|
      shell.say("      - #{k}: #{v.inspect}", :green)
    end
    shell.say("      - members", :green)
    @team.members.each do |member|
      shell.say("        - #{member}", :green)
    end
    shell.say("      - repositories", :green)
    @team.repositories.each do |repo|
      shell.say("        - #{repo.name}", :green)
    end
  end

  def order
    0
  end

  def call(client)
    created = client.create_team(
      client.org,
      @team.attributes.select {|k,v| !v.nil? }.merge(name: @team.name)
    )
    @team.members.each do |member|
      client.add_team_member(created.id, member)
    end
    @team.repositories.each do |repo|
      client.add_team_repository(
        created.id, "#{client.org}/#{repo.name}", permission: repo.permission
      )
    end
  end
end
