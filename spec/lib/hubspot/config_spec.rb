describe CommunityHubspot::Config do
  describe "#configure" do
    let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2", portal_id: "62515"} }
    subject{ CommunityHubspot::Config.configure(config) }

    it "changes the hapikey config" do
      expect{ subject }.to change(CommunityHubspot::Config, :hapikey).to("demo")
    end

    it "changes the base_url" do
      expect{ subject }.to change(CommunityHubspot::Config, :base_url).to("http://api.hubapi.com/v2")
    end

    it "sets a default value for base_url" do
      CommunityHubspot::Config.base_url.should == "https://api.hubapi.com"
    end

    it "sets a value for portal_id" do
      expect{ subject }.to change(CommunityHubspot::Config, :portal_id).to("62515")
    end
  end

  describe "#reset!" do
    let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2", portal_id: "62515"} }
    before{ CommunityHubspot::Config.configure(config) }
    subject{ CommunityHubspot::Config.reset! }
    it "clears out the config" do
      subject
      CommunityHubspot::Config.hapikey.should be_nil
      CommunityHubspot::Config.base_url.should == "https://api.hubapi.com"
      CommunityHubspot::Config.portal_id.should be_nil
    end
  end

  describe "#ensure!" do
    subject{ CommunityHubspot::Config.ensure!(:hapikey, :base_url, :portal_id)}
    before{ CommunityHubspot::Config.configure(config) }

    context "with a missing parameter" do
      let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2"} }
      it "should raise an error" do
        expect { subject }.to raise_error CommunityHubspot::ConfigurationError
      end
    end

    context "with all requried parameters" do
      let(:config){ {hapikey: "demo", base_url: "http://api.hubapi.com/v2", portal_id: "62515"} }
      it "should not raise an error" do
        expect { subject }.to_not raise_error
      end
    end
  end
end
