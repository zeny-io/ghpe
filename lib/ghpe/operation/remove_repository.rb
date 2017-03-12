require 'ghpe/operation'

class Ghpe::Operation::RemoveRepository
  def initialize(team, repo)
    @team = team
    @repo = repo
  end

  def display(shell)
    shell.say("-   Remove repository: #{@team.name} #{@repo.name}", :red)
  end

  def order
    6
  end

  def call(client)
    client.remove_team_repository(@team.id, "#{client.org}/#{@repo.name}")
  end
end
