require File.expand_path("../../src/json_query", __FILE__)
require "pry"
require "json"

class RSpec::Expectations::ExpectationTarget
  def all_satisfy?(&block)
    @target.all?(&block)
  end
end

describe NestedHash do
  let(:raw){ JSON.parse File.open("spec/sample.json").read }
  let(:nh){ NestedHash.new(raw) }
  describe(".ls") do
    it("support star query") do
      paths = nh.ls("*")
      expect(paths).to(eq(raw.keys))
    end

    it("support multiple star query") do
      paths = nh.ls("*/*/*")
      matcher = /[[:alpha:]]+\/[[:digit:]]+\/[[:alpha:]]+/
      expect(paths).all_satisfy?{|x| x.match(matcher)}
    end
  end
end
