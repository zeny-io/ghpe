require 'ghpe/operation'

class Ghpe::Operation::ModifyTeam
  def initialize(new, old)
    @new = new
    @old = old
  end

  def diff
    @new.attributes.select do |k, v|
      v != @old.attributes[k]
    end
  end

  def display(shell)
    shell.say("+/- Update team: #{@new.name}", :yellow)
    diff.each_pair do |k, v|
      shell.say("      - #{k}: #{@old.attributes[k]} -> #{v}", :yellow)
    end
  end

  def order
    1
  end

  def call(client)
    client.update_team(@old.id, diff)
  end
end

