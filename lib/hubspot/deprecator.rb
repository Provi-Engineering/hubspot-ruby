module CommunityHubspot
  class Deprecator
    def self.build(version: "1.0")
      ActiveSupport::Deprecation.new(version, "community-hubspot-ruby")
    end
  end
end
