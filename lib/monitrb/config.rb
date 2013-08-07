module MonitRB
  class Config
    attr_accessor :process

    def self.create
      config = self.new

      yield(config) if block_given?

      config
    end
  end
end
