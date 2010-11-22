require 'spec_helper'

describe OAuth2::Provider::AuthorizationCode do
  describe "any instance" do
    subject do
      OAuth2::Provider::AuthorizationCode.new(
        :client => OAuth2::Provider::Client.new,
        :redirect_uri => "http://redirect.example.com/callback"
      )
    end

    it "is valid with a client, expiry time, redirect uri and code" do
      subject.should be_valid
    end

    it "is invalid without a redirect_uri" do
      subject.redirect_uri = nil
      subject.should_not be_valid
    end

    it "is invalid without a code" do
      subject.code = nil
      subject.should_not be_valid
    end

    it "is invalid without a client" do
      subject.client = nil
      subject.should_not be_valid
    end

    it "is invalid when expires_at isn't set" do
      subject.expires_at = nil
      subject.should_not be_valid
    end

    it "has expired when expires_at is in the past" do
      subject.expires_at = 1.second.ago
      subject.should be_expired
    end

    it "has not expired when expires_at is now or in the future" do
      subject.expires_at = Time.zone.now
      subject.should_not be_expired
    end
  end

  describe "a new instance" do
    subject do
      Timecop.freeze
      OAuth2::Provider::AuthorizationCode.new
    end

    it "is assigned a randomly generated code" do
      subject.code.should_not be_nil
      OAuth2::Provider::AuthorizationCode.new.code.should_not be_nil
      subject.code.should_not == OAuth2::Provider::AuthorizationCode.new.code
    end

    it "expires in 10 minutes by default" do
      subject.expires_at.should == 10.minutes.from_now
    end
  end

  describe "a saved instance" do
    subject do
      OAuth2::Provider::AuthorizationCode.create!(
        :client => OAuth2::Provider::Client.create!,
        :redirect_uri => "https://client.example.com/callback/here"
      )
    end

    it "can be claimed with the correct code and redirect_uri" do
      OAuth2::Provider::AuthorizationCode.claim(subject.code, subject.redirect_uri).should_not be_nil
    end

    it "returns an access token when claimed" do
      OAuth2::Provider::AuthorizationCode.claim(subject.code, subject.redirect_uri).should be_instance_of(OAuth2::Provider::AccessToken)
    end

    it "can't be claimed twice" do
      OAuth2::Provider::AuthorizationCode.claim(subject.code, subject.redirect_uri)
      OAuth2::Provider::AuthorizationCode.claim(subject.code, subject.redirect_uri).should be_nil
    end

    it "can't be claimed without a matching code" do
      OAuth2::Provider::AuthorizationCode.claim("incorrectCode", subject.redirect_uri).should be_nil
    end

    it "can't be claimed without a matching redirect_uri" do
      OAuth2::Provider::AuthorizationCode.claim(subject.code, "https://wrong.example.com").should be_nil
    end

    it "can't be claimed once expired" do
      Timecop.travel subject.expires_at + 1.minute
      OAuth2::Provider::AuthorizationCode.claim(subject.code, subject.redirect_uri).should be_nil
    end
  end

  describe "the access token returned when a code is claimed" do
    subject do
      @code = OAuth2::Provider::AuthorizationCode.create!(
        :redirect_uri => "https://client.example.com/callback/here",
        :client => OAuth2::Provider::Client.create!,
        :account => Account.create!,
        :scope => 'eat drink'
      )
      OAuth2::Provider::AuthorizationCode.claim(@code.code, @code.redirect_uri)
    end

    it "is saved to the database" do
      subject.should_not be_new_record
    end

    it "has same scope as claimed code" do
      subject.scope.should == @code.scope
    end

    it "has same client as claimed code" do
      subject.client.should == @code.client
    end

    it "has same resource owner as claimed code" do
      subject.account.should == @code.account
    end
  end
end