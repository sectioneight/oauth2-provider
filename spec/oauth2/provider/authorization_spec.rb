require 'spec_helper'

describe OAuth2::Provider::Authorization do
  let(:authorization) { OAuth2::Provider::Authorization.new(params) }
  
  let(:params) { { 'response_type' => 'code',
                   'client_id'     => @client.client_id,
                   'redirect_uri'  => @client.redirect_uri }
               }
  
  let(:resource_owner) { TestApp::User['Bob'] }
  
  before do
    @client = Factory(:client)
    OAuth2.stub(:random_string).and_return('random_string')
  end
  
  describe "with valid parameters" do
    it "is valid" do
      authorization.error.should be_nil
    end
  end
  
  describe "with the state parameter" do
    before { params['scope'] = 'foo bar qux' }
    
    it "exposes the scope as a list of strings" do
      authorization.scope.should == %w[foo bar qux]
    end
  end
  
  describe "missing response_type" do
    before { params.delete('response_type') }
    
    it "is invalid" do
      authorization.error.should == "invalid_request"
      authorization.error_description.should == "Missing required parameter response_type"
    end
  end
  
  describe "with a bad response_type" do
    before { params['response_type'] = "no_such_type" }
    
    it "is invalid" do
      authorization.error.should == "unsupported_response_type"
      authorization.error_description.should == "Response type no_such_type is not supported"
    end
  end
  
  describe "missing client_id" do
    before { params.delete('client_id') }
    
    it "is invalid" do
      authorization.error.should == "invalid_request"
      authorization.error_description.should == "Missing required parameter client_id"
    end
  end
  
  describe "with an unknown client_id" do
    before { params['client_id'] = "unknown" }
    
    it "is invalid" do
      authorization.error.should == "invalid_client"
      authorization.error_description.should == "Unknown client ID unknown"
    end
  end
  
  describe "missing redirect_uri" do
    before { params.delete('redirect_uri') }
    
    it "is invalid" do
      authorization.error.should == "invalid_request"
      authorization.error_description.should == "Missing required parameter redirect_uri"
    end
  end
  
  describe "with a mismatched redirect_uri" do
    before { params['redirect_uri'] = "http://songkick.com" }
    
    it "is invalid" do
      authorization.error.should == "redirect_uri_mismatch"
      authorization.error_description.should == "Parameter redirect_uri does not match registered URI"
    end
    
    describe "when the client has not registered a redirect_uri" do
      before { @client.update_attribute(:redirect_uri, nil) }
      
      it "is valid" do
        authorization.error.should be_nil
      end
    end
  end
  
  describe "#grant_access!" do
    describe "for code requests" do
      before do
        params['response_type'] = 'code'
        params['scope'] = 'foo bar'
      end
      
      it "creates a code for the authorization" do
        authorization.grant_access!(resource_owner)
        authorization.code.should == "random_string"
        authorization.access_token.should be_nil
        authorization.expires_in.should == 3600
      end
      
      it "creates an Authorization in the database" do
        authorization.grant_access!(resource_owner)
        
        authorization = OAuth2::Model::Authorization.first
        authorization.owner.should == resource_owner
        authorization.client.should == @client
        authorization.code.should == "random_string"
        authorization.scope_list.should == %w[foo bar]
        
        expiry = authorization.expires_at - Time.now
        expiry.ceil.should == 3600
      end
    end
    
    describe "for token requests" do
      before { params['response_type'] = 'token' }
      
      it "creates a token for the authorization" do
        authorization.grant_access!(resource_owner)
        authorization.code.should be_nil
        authorization.access_token.should == "random_string"
        authorization.refresh_token.should == "random_string"
        authorization.expires_in.should == 3600
      end
      
      it "creates an Authorization in the database" do
        authorization.grant_access!(resource_owner)
        
        authorization = OAuth2::Model::Authorization.first
        authorization.owner.should == resource_owner
        authorization.client.should == @client
        authorization.code.should be_nil
        authorization.access_token.should == "random_string"
        authorization.refresh_token.should == "random_string"
        
        expiry = authorization.expires_at - Time.now
        expiry.ceil.should == 3600
      end
    end
    
    describe "for code_and_token requests" do
      before { params['response_type'] = 'code_and_token' }
      
      it "creates a code and token for the authorization" do
        authorization.grant_access!(resource_owner)
        authorization.code.should == "random_string"
        authorization.access_token.should == "random_string"
        authorization.refresh_token.should == "random_string"
        authorization.expires_in.should == 3600
      end
      
      it "creates an Authorization in the database" do
        authorization.grant_access!(resource_owner)
        
        authorization = OAuth2::Model::Authorization.first
        authorization.owner.should == resource_owner
        authorization.client.should == @client
        authorization.code.should == "random_string"
        authorization.access_token.should == "random_string"
        authorization.refresh_token.should == "random_string"
        
        expiry = authorization.expires_at - Time.now
        expiry.ceil.should == 3600
      end
    end
  end
  
  describe "#deny_access!!" do
    it "puts the authorization in an error state" do
      authorization.deny_access!
      authorization.error.should == "access_denied"
      authorization.error_description.should == "The user denied you access"
    end
    
    it "does not create an Authorization" do
      OAuth2::Model::Authorization.should_not_receive(:create)
      authorization.deny_access!
    end
  end
end
