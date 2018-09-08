require 'rails_helper'

shared_examples 'attribute accessor' do |method_name|
  subject { described_class.public_send method_name, value }

  let(:value) { 'anything' }

  it 'writes the value' do
    expect { subject }.to change { described_class.get method_name }.
      from(nil).to(value)
  end
end

describe Adapter::Options do
  describe '.topic' do
    include_examples 'attribute accessor', 'topic'
  end

  describe 'subscription' do
    include_examples 'attribute accessor', 'subscription'
  end

  describe 'project_id' do
    include_examples 'attribute accessor', 'project_id'
  end
end
