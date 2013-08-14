module MonitRB
  class Config
    attr_accessor :conditions,
                  :env,
                  :name,
                  :pid_file,
                  :pwd,
                  :shell_command,
                  :start,
                  :stop,
                  :type
    @@stack = []

    def self.create
      config = self.new

      yield(config) if block_given?

      config
    end

    def self.define(&block)
      config = self.create(&block)
      stack << config
    end

    def self.stack
      @@stack
    end

    def self.clear_stack
      @@stack = []
    end

    def get_binding
      binding
    end

    def conditions=(c)
      @conditions = c.join("\n  ")
    end

    def env=(e)
      @env = e.map do |key, value|
        "#{key.to_s.upcase}=#{value}"
      end.join(' ')
    end
  end
end
