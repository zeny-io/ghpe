require 'ghpe/operation'

class Ghpe::Operation::ModifyRepository
  def initialize(team, repo)
    @team = team
    @repo = repo
  end

  def display(shell)
    shell.say("+/- Update repository: #{@team.name} #{@repo.name}", :yellow)
    shell.say("      - permission: #{@repo.permission}", :yellow)
  end

  def order
    5
  end

  def call(client)
    client.add_team_repository(
      @team.id, "#{client.org}/#{@repo.name}", permission: @repo.permission
    )
  end
end

