RSpec.describe CommunityHubspot::Deprecator do
  describe ".build" do
    it "returns an instance of ActiveSupport::Deprecation" do
      deprecator = CommunityHubspot::Deprecator.build

      expect(deprecator).to be_an_instance_of(ActiveSupport::Deprecation)
    end

    it "uses the correct gem name" do
      deprecator = CommunityHubspot::Deprecator.build

      expect(deprecator.gem_name).to eq("hubspot-ruby")
    end
  end
end
