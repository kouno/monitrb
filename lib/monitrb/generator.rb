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
      @configs << Template.read(config)
    end

    def write_to(filepath)
      File.open(filepath, 'w') { |f| f.write(self.to_s) }
    end

    def to_s
      @configs.join("\n\n")
    end
  end
end
