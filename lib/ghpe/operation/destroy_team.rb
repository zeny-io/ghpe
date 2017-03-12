require 'ghpe/operation'

class Ghpe::Operation::DestroyTeam
  def initialize(team)
    @team = team
  end

  def display(shell)
    shell.say("-   Delete team: #{@team.name}", :red)
  end

  def order
    7
  end

  def call(client)
    client.delete_team(@team.id)
  end
end

