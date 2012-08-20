require 'spec_helper'

describe Company do
  include Rack::Test::Methods

  subject { Fabricate.build(:company) }

  it { should be_instance_of(Company) }

  it { should be_valid }

end
