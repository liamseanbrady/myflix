require 'spec_helper'

describe Category do
  it { is_expected.to have_many(:videos) }
end
