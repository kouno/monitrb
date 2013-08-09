module MonitRB
  class Generator
    def run(config)
      ERB.new(File.read(File.join(File.dirname(__FILE__), 'template', 'process.erb'))).result(config.get_binding)
    end
  end
end
