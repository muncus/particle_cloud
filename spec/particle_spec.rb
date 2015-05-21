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
    before { @client = Particle::Client.new("good_auth_token") }

    subject { @client }

    describe "#devices" do
      it "lists devices" do
        VCR.use_cassette("devices") do
          list = subject.devices
          expect(list).to be_a Array
        end
      end
    end
  end
end
