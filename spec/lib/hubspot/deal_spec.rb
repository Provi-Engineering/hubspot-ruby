describe CommunityHubspot::Deal do
  let(:portal_id) { 62515 }
  let(:company_id) { 8954037 }
  let(:vid) { 27136 }
  let(:amount) { '30' }

  let(:example_deal_hash) do
    VCR.use_cassette("deal_example") do
      HTTParty.get("https://api.hubapi.com/deals/v1/deal/3?hapikey=demo&portalId=#{portal_id}").parsed_response
    end
  end

  before{ CommunityHubspot.configure(hapikey: "demo") }

  describe "#initialize" do
    subject{ CommunityHubspot::Deal.new(example_deal_hash) }
    it  { should be_an_instance_of CommunityHubspot::Deal }
    # its (:portal_id) { should == portal_id }
    # its (:deal_id) { should == 3 }
    it 'has correct properties' do
      # expect(subject[:deal_id]).to eq(3)
      # expect(subject[:portal_id]).to eq(portal_id)
    end
  end

  describe ".create!" do
    cassette "deal_create"
    subject { CommunityHubspot::Deal.create!(portal_id, [company_id], [vid], {}) }
    # its(:deal_id)     { should_not be_nil }
    # its(:portal_id)   { should eql portal_id }
    # its(:company_ids) { should eql [company_id]}
    # its(:vids)        { should eql [vid]}
    it 'has correct properties' do
      # expect(subject[:deal_id]).not_to be_nil
      # expect(subject[:portal_id]).to eq(portal_id)
      # expect(subject[:company_ids]).to eq([company_id])
      # expect(subject[:vids]).to eq([vid])
    end
  end

  describe ".find" do
    cassette "deal_find"
    let(:deal) {CommunityHubspot::Deal.create!(portal_id, [company_id], [vid], { amount: amount})}

    it 'must find by the deal id' do
      find_deal = CommunityHubspot::Deal.find(deal.deal_id)
      find_deal.deal_id.should eql deal.deal_id
      find_deal.properties["amount"].should eql amount
    end
  end

  describe '.find_by_company' do
    cassette 'deal_find_by_company'
    let(:company) { CommunityHubspot::Company.create!('Test Company') }
    let(:deal) { CommunityHubspot::Deal.create!(portal_id, [company.vid], [vid], { amount: amount }) }

    it 'returns company deals' do
      deals = CommunityHubspot::Deal.find_by_company(company)
      deals.first.deal_id.should eql deal.deal_id
      deals.first.properties['amount'].should eql amount
    end
  end

  describe '.recent' do
    cassette 'find_all_recent_updated_deals'

    it 'must get the recents updated deals' do
      deals = CommunityHubspot::Deal.recent

      first = deals.first
      last = deals.last

      expect(first).to be_a CommunityHubspot::Deal
      expect(first.properties['amount']).to eql '0'
      expect(first.properties['dealname']).to eql '1420787916-gou2rzdgjzx2@u2rzdgjzx2.com'
      expect(first.properties['dealstage']).to eql 'closedwon'

      expect(last).to be_a CommunityHubspot::Deal
      expect(last.properties['amount']).to eql '250'
      expect(last.properties['dealname']).to eql '1420511993-U9862RD9XR@U9862RD9XR.com'
      expect(last.properties['dealstage']).to eql 'closedwon'
    end

    it 'must filter only 2 deals' do
      deals = CommunityHubspot::Deal.recent(count: 2)
      expect(deals.size).to eql 2
    end

    it 'it must offset the deals' do
      deal = CommunityHubspot::Deal.recent(count: 1, offset: 1).first
      expect(deal.properties['dealname']).to eql '1420704406-goy6v83a97nr@y6v83a97nr.com'  # the third deal
    end
  end

  describe '#destroy!' do
    cassette 'destroy_deal'

    let(:deal) {CommunityHubspot::Deal.create!(portal_id, [company_id], [vid], {amount: amount})}

    it 'should remove from hubspot' do
      pending
      expect(CommunityHubspot::Deal.find(deal.deal_id)).to_not be_nil

      expect(deal.destroy!).to be_truthy
      expect(deal.destroyed?).to be_truthy

      expect(CommunityHubspot::Deal.find(deal.deal_id)).to be_nil
    end
  end

  describe '#[]' do
    subject{ CommunityHubspot::Deal.new(example_deal_hash) }

    it 'should get a property' do
      subject.properties.each do |property, value|
        expect(subject[property]).to eql value
      end
    end
  end
end
