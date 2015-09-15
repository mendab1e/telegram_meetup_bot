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
      let(:message) { instance_double('message', text: '/date 08.11.07', from: from) }

      it { expect(subject.command).to eq('date') }
      it { expect(subject.params).to eq(['08.11.07']) }
    end

    context "when command contain @ and username equal to bot" do
      before { allow(TelegramMeetupBot::Initializers::ConfigLoader).to receive(:bot_name).and_return('test_bot')}
      let(:message) { instance_double('message', text: '/today_list@test_bot', from: from) }

      it { expect(subject.command).to eq('today_list') }
      it { expect(subject.params).to eq([]) }
    end

    context "when command contain @ and username isn't equal to bot" do
      before { allow(TelegramMeetupBot::Initializers::ConfigLoader).to receive(:bot_name).and_return('production_bot')}
      let(:message) { instance_double('message', text: '/today_list@test_bot', from: from) }

      it { expect(subject.command).to eq(nil) }
      it { expect(subject.params).to eq([]) }
    end
  end

  describe '#author' do
    context "returns struct with author's data" do
      user = TelegramMeetupBot::MessageParser::User.new(1, 'Ikari01', 'Shinji')
      it { expect(subject.author).to eq(user) }
    end
  end
end
