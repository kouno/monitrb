module MonitRB
  class Generator
    attr_accessor :configs

    def self.parse(configs)
      generator = self.new
      configs.each { |c| generator.add(c) }
      generator
    end

    def initialize
      @configs = []
    end

    def add(config)
      @configs << convert(config)
    end

    def convert(config)
      erb_template = ::ERB.new(File.read(File.join(File.dirname(__FILE__), 'template', 'process.erb')))
      erb_template.result(config.get_binding)
    end

    def write_to(filepath)
      File.open(filepath, 'w') { |f| f.write(self.to_s) }
    end

    def to_s
      @configs.join("\n\n")
    end
  end
end
