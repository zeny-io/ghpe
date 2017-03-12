require 'ghpe'

class Ghpe::Operation
  def self.build(new_teams, old_teams)
    op = []

    (new_teams - old_teams).each do |new_team|
      op << CreateTeam.new(new_team)
    end

    name_index = Hash[*old_teams.map {|t| [t.name, t] }.flatten]
    intersections = (new_teams & old_teams)

    intersections.each do |team|
      old = name_index[team.name]
      build_for_team(op, team, old)
    end

    (old_teams - new_teams).each do |old_team|
      op << DestroyTeam.new(old_team)
    end

    i = 0
    op.sort_by {|op| [op.order, i += 1] }
  end

  def self.build_for_team(op, new, old)
    if new.attributes != old.attributes
      op << ModifyTeam.new(new, old)
    end

    (new.members - old.members).each do |member|
      op << AddMember.new(old, member)
    end

    (old.members - new.members).each do |member|
      op << RemoveMember.new(old, member)
    end

    (new.repositories - old.repositories).each do |repo|
      op << AddRepository.new(old, repo)
    end

    name_index = Hash[*old.repositories.map {|t| [t.name, t] }.flatten]
    intersections = (new.repositories & old.repositories)
    intersections.each do |new_repo|
      old_repo = name_index[new_repo.name]

      if new_repo.permission != old_repo.permission
        op << ModifyRepository.new(old, new_repo)
      end
    end

    (old.repositories - new.repositories).each do |repo|
      op << RemoveRepository.new(old, repo)
    end
  end
end

require 'ghpe/operation/create_team'
require 'ghpe/operation/modify_team'
require 'ghpe/operation/destroy_team'
require 'ghpe/operation/add_member'
require 'ghpe/operation/remove_member'
require 'ghpe/operation/add_repository'
require 'ghpe/operation/modify_repository'
require 'ghpe/operation/remove_repository'
