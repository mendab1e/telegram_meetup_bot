require 'spec_helper'

RSpec.describe TelegramMeetupBot::MessageParser do
  let(:from) { instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji') }
  let(:message) { instance_double('message', text: '/today', from: from) }
  subject { described_class.new(message) }

  describe '#command_with_params' do
    context "when message doesn't start with / " do
      let(:message) { instance_double('message', text: 'today', from: from) }

      it { expect(subject.command).to eq(nil) }
      it { expect(subject.params).to eq([]) }
    end

    context "when message contain only / " do
      let(:message) { instance_double('message', text: '/', from: from) }

      it { expect(subject.command).to eq(nil) }
      it { expect(subject.params).to eq([]) }
    end

    context "when message without params" do
      let(:message) { instance_double('message', text: '/today', from: from) }

      it { expect(subject.command).to eq('today') }
      it { expect(subject.params).to eq([]) }
    end

    context "when message with params" do
      let(:message) { instance_double('message', text: '/date 08.11.1998', from: from) }

      it { expect(subject.command).to eq('date') }
      it { expect(subject.params).to eq(['08.11.1998']) }
    end
  end

  describe '#author' do
    context "returns struct with author's data" do
      user = TelegramMeetupBot::MessageParser::User.new(1, 'Ikari01', 'Shinji')
      it { expect(subject.author).to eq(user) }
    end
  end
end
