require 'pp'
require 'ghpe'
require 'ghpe/client'

class Ghpe::Exporter
  def initialize(options)
    @org = options[:organization]
    @client = Ghpe::Client.new(options)
    @options = options
  end
  attr_reader :client, :options

  def call
    if options[:split] && options[:dir]
      split_export(options[:dir], options[:file])
    else
      export(options[:file], teams)
    end
  end

  def teams
    @teams ||= Ghpe::Team.wrap(client, client.org_teams(@org))
  end

  private

  def export(file, export_teams)
    File.open(file.to_s, 'w') do |fd|
      write_modeline(fd)
      fd.puts export_teams.map(&:to_dsl).join("\n\n")
    end
  end

  def split_export(dir, file)
    dir = Pathname.new(dir)
    file = Pathname.new(file)
    Dir.mkdir(dir.to_s) unless dir.directory?

    File.open(file.to_s, 'w') do |fd|
      write_modeline(fd)
      teams.each do |team|
        teamfile = dir.join(team.name)
        export(teamfile, [team])
        fd.puts "require '#{teamfile.relative_path_from(file.dirname)}'"
      end
    end
  end

  def write_modeline(fd)
    fd << "# -*- mode: ruby -*-\n# vi: set ft=ruby :\n\n" if options[:modeline]
  end
end
