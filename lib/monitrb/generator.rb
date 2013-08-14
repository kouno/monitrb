module MonitRB
  class Generator
    attr_accessor :config

    def self.parse(config)
      generator = self.new
      generator.config = ERB.new(File.read(File.join(File.dirname(__FILE__), 'template', 'process.erb'))).result(config.get_binding)
      generator
    end

    def write_to(filepath)
      File.open(filepath, 'w') { |f| f.write(@config) }
    end

    def to_s
      @config
    end
  end
end
