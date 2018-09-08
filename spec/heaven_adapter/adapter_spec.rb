require 'rails_helper'

describe Adapter do
  describe '.enqueue' do
    let(:dummy_job_class) { Class.new(ApplicationJob) }
    let(:job) { dummy_job_class.new.tap { |j| j.queue_name = queue } }

    subject { described_class.enqueue job }

    context 'when enqueuing into default queue' do
      let(:queue) { 'default' }

      it 'works' do
        # it doesn't check that it publishes into a correct stream, though :/
        expect_any_instance_of(Adapter::Stream).to receive(:publish)
        subject
      end
    end

    context 'when enqueuing into morgue queue' do
      let(:queue) { 'morgue' }

      it 'works' do
        expect_any_instance_of(Adapter::Stream).to receive(:publish)
        subject
      end
    end

    context 'when enqueuing into other queue' do
      let(:queue) { 'rainbow' }

      it 'raises a error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
