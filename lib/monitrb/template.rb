module MonitRB
  class Template
    def self.read(config)
      self.new(config).result
    end

    def initialize(config)
      @config = config
    end

    def path
      File.join(File.dirname(__FILE__), 'template', "#{@config.type}.erb")
    end

    def result
      if @config.raw.nil? || @config.raw.empty?
        ::ERB.new(File.read(path)).result(@config.get_binding)
      else
        @config.raw
      end
    end
  end
end
