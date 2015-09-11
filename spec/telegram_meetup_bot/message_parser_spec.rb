require 'spec_helper'

RSpec.describe TelegramMeetupBot::MessageParser do
  let(:from) {instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji')}
  let(:message) {instance_double('message', text: '/today', from: from)}
  subject {described_class.new(message)}

  describe '#command_with_params' do
    context "when message doesn't start with / " do
      let(:message) {instance_double('message', text: 'today', from: from)}

      it { expect(subject.command_with_params).to eq({}) }
    end

    context "when message contain only / " do
      let(:message) {instance_double('message', text: '/', from: from)}

      it { expect(subject.command_with_params).to eq({}) }
    end

    context "when message without params" do
      let(:message) {instance_double('message', text: '/today', from: from)}

      it { expect(subject.command_with_params).to eq({command: 'today', params: []}) }
    end

    context "when message with params" do
      let(:message) {instance_double('message', text: '/date 08.11.1998', from: from)}

      it { expect(subject.command_with_params).to eq({command: 'date', params: ['08.11.1998']}) }
    end
  end

  describe '#author' do
    context "returns hash with author's data" do
      it { expect(subject.author).to eq({id: 1, username: 'Ikari01', first_name: 'Shinji'}) }
    end
  end
end
