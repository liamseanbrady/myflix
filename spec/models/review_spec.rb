require 'spec_helper'

describe Review do
  it { is_expected.to belong_to(:video) }
  it { is_expected.to belong_to(:author) }
  it { is_expected.to validate_presence_of(:rating) }
  it { is_expected.to validate_presence_of(:content) }
end
