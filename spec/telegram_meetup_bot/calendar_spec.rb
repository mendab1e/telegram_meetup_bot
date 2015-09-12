require 'spec_helper'

RSpec.describe TelegramMeetupBot::Calendar do
  let(:storage) { double('storage') }
  let(:user) { TelegramMeetupBot::MessageParser::User.new(1, 'Ikari01', 'Shinji') }
  subject { described_class.new(storage: storage, user: user, date: Date.today, time: '10:00') }

  describe '#delete_user_from_date' do
    before { allow(storage).to receive(:set_users_to_date) }

    context "when user exists in storage on selected date" do
      before { allow(storage).to receive(:get_users_for_date).and_return([user.to_h]) }

      it { expect(subject.delete_user_from_date).to eq(true) }
      it 'set array without user to storage' do
        expect(storage).to receive(:set_users_to_date).with([], Date.today)
        subject.delete_user_from_date
      end
    end

    context "when user doesn't exists in storage on selected date" do
      before { allow(storage).to receive(:get_users_for_date).and_return([]) }

      it { expect(subject.delete_user_from_date).to eq(nil) }
      it 'set array without user to storage' do
        expect(storage).not_to receive(:set_users_to_date)
        subject.delete_user_from_date
      end
    end
  end

  describe '#add_user_to_date' do
    before { allow(storage).to receive(:set_users_to_date) }

    context "when user exists in storage on selected date with equal hash" do
      before { allow(storage).to receive(:get_users_for_date).and_return([user.to_h.merge(time: '10:00')]) }

      it "doesn't update storage" do
        expect(storage).not_to receive(:set_users_to_date)
        subject.add_user_to_date
      end
    end

    context "when user exists in storage on selected date with different hash" do
      before { allow(storage).to receive(:get_users_for_date).and_return([user.to_h.merge(time: '11:00')]) }

      it "updates storage with new user hash" do
        expect(storage).to receive(:set_users_to_date).with([user.to_h.merge(time: '10:00')], Date.today)
        subject.add_user_to_date
      end
    end

    context "when user doesn't exist in storage on selected date " do
      before { allow(storage).to receive(:get_users_for_date).and_return([]) }

      it "updates storage with new user hash" do
        expect(storage).to receive(:set_users_to_date).with([user.to_h.merge(time: '10:00')], Date.today)
        subject.add_user_to_date
      end
    end
  end
end
