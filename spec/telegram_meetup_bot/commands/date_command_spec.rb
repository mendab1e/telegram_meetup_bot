require 'spec_helper'

RSpec.describe TelegramMeetupBot::Commands::DateCommand do
  before { allow(TelegramMeetupBot::Initializers::ConfigLoader).to receive(:storage).and_return(storage)}
  let(:storage) { double('storage') }
  let(:from) { instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji') }
  let(:message) { instance_double('message', text: command, from: from) }
  let(:message_parser) { TelegramMeetupBot::MessageParser.new(message) }

  describe '#exec' do
    subject { described_class.new(message_parser) }

    context 'valid date' do
      let(:command) { '/date 21.01.16' }

      it 'works' do
        allow_any_instance_of(TelegramMeetupBot::Calendar).to receive(:add_user_to_date)
        allow(subject).to receive(:build_response).and_return(true)
        expect_any_instance_of(TelegramMeetupBot::Calendar).to receive(:add_user_to_date)
        subject.exec
      end
    end

    context 'invalid date' do
      let(:command) { '/date 213.01.2015' }

      it 'works' do
        allow_any_instance_of(TelegramMeetupBot::Calendar).to receive(:add_user_to_date)
        allow(subject).to receive(:build_response).and_return(true)
        expect_any_instance_of(TelegramMeetupBot::Calendar).not_to receive(:add_user_to_date)
        subject.exec
      end
    end
  end
end
