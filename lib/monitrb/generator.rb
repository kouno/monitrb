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
      if config.raw.nil? || config.raw.empty?
        @configs << Template.read(config)
      else
        @configs << config.raw
      end
    end

    def write_to(filepath)
      File.open(filepath, 'w') { |f| f.write(self.to_s) }
    end

    def to_s
      @configs.join("\n")
    end
  end
end
