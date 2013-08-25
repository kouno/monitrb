module MonitRB
  class Template
    def self.read(config)
      self.new(config).result
    end

    def initialize(config)
      @config = config
    end

    def path
      File.join(File.dirname(__FILE__), 'template', 'process.erb')
    end

    def result
      ::ERB.new(File.read(path)).result(@config.get_binding)
    end
  end
end
