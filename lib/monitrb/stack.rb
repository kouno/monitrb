module MonitRB
  module Stack
    @@values = []

    def add(config)
      @@values << config
    end

    def clear_stack
      @@values = []
    end

    def stack
      @@values
    end
  end
end
