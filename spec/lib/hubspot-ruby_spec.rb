describe CommunityHubspot do
  describe "#configure" do
    it "delegates a call to CommunityHubspot::Config.configure" do
      skip
      mock(CommunityHubspot::Config).configure({hapikey: "demo"})
      CommunityHubspot.configure hapikey: "demo"
    end
  end
end
