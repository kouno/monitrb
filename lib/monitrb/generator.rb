module MonitRB
  class Generator
    attr_accessor :configs

    def initialize
      @configs = []
    end

    def load(configs)
      @configs = configs
      self
    end

    def write_to(filepath)
      File.open(filepath, 'w') { |f| f.write(self.to_s) }
    end

    def to_s
      @configs.join("\n")
    end
  end
end
