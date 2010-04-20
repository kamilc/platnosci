require File.dirname(__FILE__) + '/../spec_helper'

describe PlatnosciGateway do
  before(:each) do
    @platnosci_gateway = PlatnosciGateway.new
  end

  it "should be valid" do
    @platnosci_gateway.should be_valid
  end
end
