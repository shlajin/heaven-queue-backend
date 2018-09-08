require 'rails_helper'

describe Worker::Counter do
  let(:instance) { described_class.new }
  let(:job_id) { '1' }

  describe 'dead_job?' do
    subject { instance.dead_job? job_id }

    before do
      attempts_count.times { instance.job_started! job_id }
    end

    context 'when no attempts has been made' do
      let(:attempts_count) { 0 }

      it { is_expected.to be_falsey }
    end

    context 'with few attempts' do
      let(:attempts_count) { 2 }

      it { is_expected.to be_falsey }
    end

    context 'with 3 attempts' do
      let(:attempts_count) { 3 }

      it { is_expected.to be_truthy }

      context 'when querying another job' do
        subject { instance.dead_job? 'another-job-id' }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#remove_job!' do
    subject { instance.remove_job! job_id }

    before do
      # make it dead
      3.times { instance.job_started! job_id }
    end

    it 'forgets about this job' do
      expect { subject }.to change { instance.dead_job?(job_id) }.from(true).to(false)
    end
  end
end
