module MonitRB
  class Config
    extend MonitRB::Stack

    attr_accessor :conditions,
                  :env,
                  :name,
                  :path,
                  :pid_file,
                  :pwd,
                  :raw,
                  :shell_command,
                  :start,
                  :stop,
                  :type

    @@defaults = {}

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

    def self.defaults(values)
      raise MonitRB::Exceptions::UnexpectedConfigurationVariable.new(values) unless self.has_known_keys?(values)
      @@defaults = values
    end

    def self.has_known_keys?(values)
      config = self.new
      values.keys.all? do |key|
        config.respond_to?(key)
      end
    end

    def initialize
      set_defaults(@@defaults)
    end

    def set_defaults(options)
      options.each do |key, value|
        send("#{key}=", value)
      end
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
