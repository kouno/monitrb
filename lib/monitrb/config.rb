module MonitRB
  class Config
    attr_accessor :process,
                  :pid_file,
                  :shell_command,
                  :env,
                  :pwd,
                  :start,
                  :stop

    def self.create
      config = self.new

      yield(config) if block_given?

      config
    end
  end
end
