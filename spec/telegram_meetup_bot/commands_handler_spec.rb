require 'spec_helper'

RSpec.describe TelegramMeetupBot::CommandsHandler do
  let(:messenger) { instance_double('message') }
  let(:from) { instance_double('from', id: 1, username: 'Ikari01', first_name: 'Shinji') }
  let(:message) { instance_double('message', text: command, from: from) }

  subject { described_class.new(message: message, messenger: messenger) }

  describe '#process' do
    context "when command isn't in whitelist" do
      let(:command) { '/unknow_command' }

      it "calls help command" do
        allow_any_instance_of(TelegramMeetupBot::HandlerHelper).to receive(:handle_default_command)
        expect(subject).to receive(:help).with(no_args)
        subject.process
      end
    end

    context "when command without args" do
      let(:command) { '/today_list' }

      it "works" do
        allow_any_instance_of(TelegramMeetupBot::HandlerHelper).to receive(:handle_date_list)
        expect(subject).to receive(:today_list).with(no_args)
        subject.process
      end
    end

    context "when command with args" do
      let(:command) { '/date 08.11.07' }

      it "works" do
        allow_any_instance_of(TelegramMeetupBot::HandlerHelper).to receive(:handle_date)
        expect(subject).to receive(:date).with(['08.11.07'])
        subject.process
      end
    end
  end
end
