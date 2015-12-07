require 'spec_helper'

RSpec.describe TelegramMeetupBot::Commands::Factory do
  let(:from) { instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji') }
  let(:message) { instance_double('message', text: command, from: from) }
  let(:message_parser) { TelegramMeetupBot::MessageParser.new(message) }

  describe 'self#build' do
    subject { described_class.build(message_parser) }

    context 'command in blacklist' do
      let(:command) { '/me' }

      it 'works' do
        expect(subject).to eq(nil)
      end
    end

    context 'available command' do
      let(:command) { '/date' }

      it 'works' do
        expect(subject.class).to eq(TelegramMeetupBot::Commands::Date)
      end
    end

    context 'not available command' do
      let(:command) { '/qwerty' }

      it 'uses default command' do
        expect(subject.class).to eq(TelegramMeetupBot::Commands::Help)
      end
    end
  end
end
