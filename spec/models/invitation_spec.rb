require 'spec_helper'

describe Invitation do
  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:recipient_email) }
  it { is_expected.to validate_presence_of(:message) }

  it 'generates a random token when a user is created' do
    invitation = Fabricate(:invitation)

    expect(invitation.token).not_to be_blank
  end
end
