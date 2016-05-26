require 'spec_helper'

RSpec.describe TelegramMeetupBot::Commands::ListCommand do
  before { allow(TelegramMeetupBot::Initializers::ConfigLoader).to receive(:storage).and_return(storage)}
  let(:storage) { double('storage') }
  let(:from) { instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji') }
  let(:message) { instance_double('message', text: command, from: from) }
  let(:message_parser) { TelegramMeetupBot::MessageParser.new(message) }

  describe '#exec' do
    subject { described_class.new(message_parser) }

    context 'valid date' do
      let(:command) { "/list #{(Date.today + 1).strftime('%d.%m.%y')}" }

      it 'works' do
        allow(TelegramMeetupBot::Calendar).to receive(:formated_users_for_date)
        allow(subject).to receive(:build_response).and_return(true)
        allow(subject).to receive(:list_response).and_return(true)
        expect(TelegramMeetupBot::Calendar).to receive(:formated_users_for_date)
        subject.exec
      end
    end

    context 'invalid date' do
      let(:command) { '/list 213.01.2015' }

      it 'works' do
        allow(TelegramMeetupBot::Calendar).to receive(:formated_users_for_date)
        allow(subject).to receive(:build_response).and_return(true)
        allow(subject).to receive(:list_response).and_return(true)
        expect(TelegramMeetupBot::Calendar).not_to receive(:formated_users_for_date)
        subject.exec
      end
    end
  end
end
