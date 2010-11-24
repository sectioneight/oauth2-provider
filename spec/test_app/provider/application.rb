require 'sinatra'

module TestApp
  class Provider < Sinatra::Base
    
    extend Helper::RackRunner
    
    set :views, File.dirname(__FILE__) + '/views'
    
    def handle_authorize
      @request = OAuth2::Rack.request(env)
      redirect @request.redirect_uri if @request.redirect?
      
      headers @request.response_headers
      status  @request.response_status
      
      @request.response_body || erb(:authorize)
    end
    
    def serve_protected_resource
      @user = User['Bob']
      @auth = OAuth2::Rack.access_token(env)
      if @user.grants_access?(@auth, 'profile')
        JSON.unparse('data' => 'Top secret')
      else
        JSON.unparse('data' => 'No soup for you')
      end
    end
    
    [:get, :post].each do |method|
      __send__(method, '/authorize') { handle_authorize }
    end
    
    post '/allow' do
      @request = OAuth2::Provider::Authorization.new(params)
      @user = User['bob']
      if params['allow'] == '1'
        @request.grant_access!(@user)
      else
        @request.deny_access!
      end
      redirect @request.redirect_uri
    end
    
    [:get, :post].each do |method|
      __send__(method, '/user_profile') { serve_protected_resource }
    end
    
  end
end
