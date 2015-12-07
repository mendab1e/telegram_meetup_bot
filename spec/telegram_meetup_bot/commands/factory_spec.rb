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
        expect(subject.class).to eq(TelegramMeetupBot::Commands::DateCommand)
      end
    end

    context 'not available command' do
      let(:command) { '/qwerty' }

      it 'uses default command' do
        expect(subject.class).to eq(TelegramMeetupBot::Commands::HelpCommand)
      end
    end

    context 'user without username' do
      let(:from) { instance_double('from', id: 1, username: nil, first_name: 'Shinji') }
      let(:command) { '/date' }

      it 'does something' do
        expect(subject.class).to eq(TelegramMeetupBot::Commands::NilUsername)
      end
    end
  end
end
