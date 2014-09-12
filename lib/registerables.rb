module Registerables
  class Base < Struct.new(:metadata)
    def state
      "live"
    end

    def slug
      metadata["slug"]
    end

    def title
      metadata["name"]
    end

    def description
      raise NotImplementedError
    end

    def paths
      raise NotImplementedError
    end
  end

  class Schema < Base
    def description
      ""
    end

    def paths
      ["/#{slug}", "/#{slug}.json"]
    end
  end
end
