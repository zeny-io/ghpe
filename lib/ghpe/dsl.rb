require 'ghpe'

class Ghpe::DSL
  def initialize(file, context = {})
    @file = Pathname.new(file)
    @dir = @file.dirname
    @teams = []
    @files = []

    @context = context
  end
  attr_reader :teams

  def call(client)
    evaluate(@file)

    transform(client)
  end

  def require(path)
    if @dir.join(path).exist?
      evaluate(@dir.join(path))
    elsif @dir.join("#{path}.rb").exist?
      evaluate(@dir.join("#{path}.rb"))
    else
      Kernel.require(path)
    end
  end

  def evaluate(file)
    @files << file.to_s
    instance_eval(File.read(file), file.to_s)
  rescue ScriptError => e
    raise Ghpe::DSL::Error, "#{e.class}: #{e.message}", cleanup_backtrace(e.backtrace)
  rescue StandardError => e
    raise Ghpe::DSL::Error, "#{e.class}: #{e.message}", cleanup_backtrace(e.backtrace)
  end

  def team(name, &block)
    @teams.push(Ghpe::DSL::Team.new(name, &block))
  end

  def transform(client)
    @teams.map do |team|
      team.transform(client)
    end
  end

  private

  def cleanup_backtrace(backtrace)
    return backtrace if @context[:debug]

    backtrace.select do |bt|
      path = bt.split(':')[0..-3].join(':')
      @files.include?(path)
    end
  end
end

require 'ghpe/dsl/error'
require 'ghpe/dsl/team'
