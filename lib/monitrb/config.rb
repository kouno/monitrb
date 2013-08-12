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

    def self.create
      config = self.new

      yield(config) if block_given?

      config
    end

    def get_binding
      binding
    end

    def format_env
      @env.map do |key, value|
        "#{key.to_s.upcase}=#{value}"
      end.join(' ')
    end
  end
end
