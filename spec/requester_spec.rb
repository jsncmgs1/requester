require "spec_helper"

RSpec.describe Requester do
  it "has a version number" do
    expect(Requester::VERSION).not_to be nil
  end
end
