require 'thor'

module MonitRB
  class CLI < ::Thor
    desc "build", "Generate monit files"
    method_option :path,   type: :string, default: '', required: true, aliases: '-p'
    method_option :output, type: :string, default: '', required: true, aliases: '-o'
    def build
      Dir.glob(options.path).each do |path|
        load path
      end

      MonitRB::Generator.parse(MonitRB::Config.stack).write_to(options.output)
    end
  end
end
