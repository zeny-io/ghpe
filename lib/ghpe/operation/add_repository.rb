require 'ghpe/operation'

class Ghpe::Operation::AddRepository
  def initialize(team, repo)
    @team = team
    @repo = repo
  end

  def display(shell)
    shell.say("+   Add repository: #{@team.name} #{@repo.name}", :green)
    shell.say("      - permission: #{@repo.permission}", :green)
  end

  def order
    4
  end

  def call(client)
    client.add_team_repository(
      @team.id, "#{client.org}/#{@repo.name}", permission: @repo.permission
    )
  end
end
