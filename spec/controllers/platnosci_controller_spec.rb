require File.dirname(__FILE__) + '/../spec_helper'

describe PlatnosciController do

  #Delete these examples and add some real ones
  it "should use PlatnosciController" do
    controller.should be_an_instance_of(PlatnosciController)
  end


  it "GET 'error' should be successful" do
    get 'error'
    response.should be_success
  end

  it "GET 'success' should be successful" do
    get 'success'
    response.should be_success
  end

  it "GET 'report' should be successful" do
    get 'report'
    response.should be_success
  end
end
