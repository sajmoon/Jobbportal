require "spec_helper"

describe "Textile" do
  describe "simple examples" do
    it { expect(Textile.to_html("text")).to include "<p>" }
  end
end
