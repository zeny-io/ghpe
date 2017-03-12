require 'ghpe/operation'

class Ghpe::Operation::AddMember
  def initialize(team, member)
    @team = team
    @member = member
  end

  def display(shell)
    shell.say("+   Add member: #{@team.name} #{@member}", :green)
  end

  def order
    2
  end

  def call(client)
    client.add_team_member(@team.id, @member)
  end
end
