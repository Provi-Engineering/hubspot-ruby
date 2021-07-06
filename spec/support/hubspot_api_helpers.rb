module CommunityHubspotApiHelpers
  def hubspot_api_url(path)
    URI.join(CommunityHubspot::Config.base_url, path)
  end
end

RSpec.configure do |c|
  c.include CommunityHubspotApiHelpers
end
