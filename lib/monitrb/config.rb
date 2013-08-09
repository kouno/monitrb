module MonitRB
  class Config
    attr_accessor :env,
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
      variables = []

      @env.map do |key, value|
        variables << "#{key.to_s.upcase}=#{value}"
      end

      variables.join(' ')
    end
  end
end
