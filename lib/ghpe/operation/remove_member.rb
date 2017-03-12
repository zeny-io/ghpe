require 'ghpe/operation'

class Ghpe::Operation::RemoveMember
  def initialize(team, member)
    @team = team
    @member = member
  end

  def display(shell)
    shell.say("-   Remove member: #{@team.name} #{@member}", :red)
  end

  def order
    3
  end

  def call(client)
    client.remove_team_member(@team.id, @member)
  end
end
