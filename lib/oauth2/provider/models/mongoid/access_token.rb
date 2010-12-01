class OAuth2::Provider::Models::Mongoid::AccessToken
  include ::Mongoid::Document
  include OAuth2::Provider::Models::Shared::AccessToken

  field :access_token
  field :expires_at, :type => Time
  field :refresh_token

  referenced_in :access_grant, :class_name => "OAuth2::Provider::Models::Mongoid::AccessGrant", :inverse_of => :access_tokens
  referenced_in :client, :class_name => "OAuth2::Provider::Models::Mongoid::Client"

  before_save do
    self.client = access_grant.client
  end

  def self.find_by_refresh_token(refresh_token)
    where(:refresh_token => refresh_token).first
  end

  def self.find_by_access_token(access_token)
    where(:access_token => access_token).first
  end
end