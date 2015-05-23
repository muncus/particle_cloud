require 'spec_helper'

describe Particle do
  it 'has a version number' do
    expect(Particle::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(true).to eq(true)
  end
end

describe Particle::Client do

  context "good access token" do
    before do
      @client = Particle::Client.new("access_token")
      @client.username = "username"
      @client.password = "password"
    end

    subject { @client }

    describe "#devices", :vcr => {cassette_name: "devices" } do

      it "lists devices" do
        list = subject.devices
        expect(list).to be_a Array
      end
    end

    describe "#access_tokens", :vcr => {cassette_name: "access_tokens"} do

      it "lists tokens" do
        list = subject.access_tokens
        expect(list.length).to be > 0
      end

      it "creates new token without expiry params" do
        r = subject.create_access_token()
        expect(r['token_type']).to eq("bearer")
        expect(r['access_token']).to_not be_nil
      end

      it "deletes a token" do
        r = subject.delete_access_token("some_auth_token")
        expect(r).to eq(true)
      end

    end
  end
end
