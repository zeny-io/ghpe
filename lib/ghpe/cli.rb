require 'thor'
require 'ghpe'

class Ghpe::CLI < Thor
  include Thor::Actions

  class_option :api_token, type: :string, aliases: %w(-t), desc: 'Your API token'
  class_option :organization, type: :string, aliases: %w(-o), desc: 'Target organization'
  class_option :debug, type: :boolean, default: false

  desc "export", "Export current permission to Ghpefile"
  method_option :file, type: :string, default: 'Ghpefile', aliases: %w(-f), desc: 'Export Ghpefile path'
  method_option :dir, type: :string, default: './ghpefiles', aliases: %w(-d), desc: 'Export directory path for split'
  method_option :split, type: :boolean, default: false, aliases: %w(-s), desc: 'Export with split by teams'
  method_option :modeline, type: :boolean, default: false, aliases: %w(-m), desc: 'Export with modeline for Vim'
  def export
    exporter = Ghpe::Exporter.new(options)

    exporter.call
  rescue => e
    rescue_from(e)
  end

  desc 'apply', 'Apply team specifications'
  method_option :dry_run, type: :boolean, default: false, aliases: %w(-d)
  method_option :file, type: :string, default: 'Ghpefile', aliases: %w(-f), desc: 'Source Ghpefile path'
  method_option :yes, type: :boolean, default: false, aliases: %w(-y), desc: 'Do not confirm on before apply'
  def apply
    applier = Ghpe::Applier.new(self, options)

    applier.call
  rescue => e
    rescue_from(e)
  end

  private

  def rescue_from(e)
    raise e if options[:debug]

    error(set_color("#{e.class}: #{e.message}", :red, :bold))
    e.backtrace.each do |bt|
      say("  #{set_color('from', :green)} #{bt}")
    end
    exit 1
  end
end
