module MonitRB
  class Config
    extend MonitRB::Stack

    attr_accessor :conditions,
                  :env,
                  :name,
                  :pid_file,
                  :pwd,
                  :raw,
                  :shell_command,
                  :start,
                  :stop,
                  :type


    def self.create
      config = self.new

      yield(config) if block_given?

      config
    end

    def self.define(&block)
      config = self.create(&block)
      self.add(config)
    end

    def self.raw(text)
      config = self.new

      config.raw = text

      self.add(config)
    end

    def to_s
      Template.read(self)
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

    def start_script
      wrap_script(@start)
    end

    def stop_script
      wrap_script(@stop)
    end

    def wrap_script(script)
      script = "cd #{@pwd} && #{script}"       if @pwd
      script = "#{@shell_command} '#{script}'" if @shell_command
      script = "#{@env} #{script}"             if @env
      script
    end
  end
end
