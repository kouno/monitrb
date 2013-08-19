require 'thor'

module MonitRB
  class CLI < ::Thor
    desc "build", "generate monit files"
    method_option :path,   type: :string, default: '', required: true
    method_option :output, type: :string, default: '', required: true
    def build
      say "Received 1 file.", :green unless options.path.empty?
      load File.join(Dir.getwd, options.path)
      MonitRB::Generator.parse(MonitRB::Config.stack.first).write_to(options.output)
    end
  end
end
