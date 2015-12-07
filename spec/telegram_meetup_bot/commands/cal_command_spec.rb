require 'spec_helper'

RSpec.describe TelegramMeetupBot::Commands::CalCommand do
  before { allow(TelegramMeetupBot::Initializers::ConfigLoader).to receive(:storage).and_return(storage)}
  let(:storage) { double('storage') }
  let(:from) { instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji') }
  let(:message) { instance_double('message', text: command, from: from) }
  let(:message_parser) { TelegramMeetupBot::MessageParser.new(message) }

  describe '#exec' do
    subject { described_class.new(message_parser) }
    let(:command) { '/cal 5' }

    context 'month is in this year' do
      it 'works' do
        allow(TelegramMeetupBot::Calendar).to receive(:submited_days_of_month)
        allow(subject).to receive(:list_response).with({month: Date.new(2015, 5, 1), list: nil})
        expect(TelegramMeetupBot::Calendar).to receive(:submited_days_of_month)
        Timecop.freeze(Date.new(2015, 4, 1)) do
          subject.exec
        end
      end
    end

    context 'month is in next year' do
      it 'works' do
        allow(TelegramMeetupBot::Calendar).to receive(:submited_days_of_month)
        allow(subject).to receive(:list_response).with({month: Date.new(2016, 5, 1), list: nil})
        expect(TelegramMeetupBot::Calendar).to receive(:submited_days_of_month)
        Timecop.freeze(Date.new(2015, 6, 1)) do
          subject.exec
        end
      end
    end
  end
end
