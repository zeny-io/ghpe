require 'ghpe'

class Ghpe::Applier
  def initialize(shell, options)
    @shell = shell
    @options = options
    @org = options[:organization]
    @client = Ghpe::Client.new(options)
  end
  attr_reader :client, :shell, :options

  def call
    dsl = Ghpe::DSL.new(options[:file], options)

    new_teams = dsl.call(@client)
    old_teams = Ghpe::Team.wrap(client, client.org_teams(@org))

    operations = Ghpe::Operation.build(new_teams, old_teams)
    operations.each do |op|
      op.display(shell)
    end

    if operations.size.zero?
      shell.say("No changes", :bold)
      return
    end

    return if options[:dry_run] || !(options[:yes] || shell.yes?("Apply #{operations.size} changes. OK?(y/n) >"))

    operations.each do |op|
      op.call(client)
    end
  end
end
