require 'spec_helper'

RSpec.describe TelegramMeetupBot::Calendar do
  let(:storage) { double('storage') }
  let(:user) { TelegramMeetupBot::MessageParser::User.new(1, 'Unit01', 'Shinji') }
  let(:user2) { TelegramMeetupBot::MessageParser::User.new(2, 'Unit02', 'Asuka') }
  before { allow(TelegramMeetupBot::Initializers::ConfigLoader).to receive(:storage).and_return(storage)}
  subject { described_class.new(user: user, date: Date.today, time: '10:00') }

  describe '#delete_user_from_date' do
    before { allow(storage).to receive(:set_users_to_date) }
    before { allow(storage).to receive(:delete_date) }

    context "when more than one users exist in storage on selected date" do
      before { allow(storage).to receive(:get_users_for_date).and_return([user.to_h, user2.to_h]) }

      it { expect(subject.delete_user_from_date).to eq(true) }
      it 'set array without user to storage' do
        expect(storage).to receive(:set_users_to_date).with([user2.to_h], Date.today)
        subject.delete_user_from_date
      end
    end

    context "when one user exists in storage on selected date" do
      before { allow(storage).to receive(:get_users_for_date).and_return([user.to_h]) }

      it { expect(subject.delete_user_from_date).to eq(true) }
      it 'delete date key from storage' do
        expect(storage).to receive(:delete_date).with(Date.today)
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

  describe 'Calendar#submited_days_of_month' do
    let(:storage) { double('storage') }
    let(:month) { 7 }
    subject { described_class }
    before { allow(storage).to receive(:get_all_available_dates).and_return(dates) }

    context "when month isn't current" do
      let(:dates) {
        {"2015-07-30"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2015-07-15"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2015-07-16"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n  :time: '10:10'\n",
         "2015-06-14"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2015-08-17"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n"}
      }
      it "works" do
        Timecop.freeze(Date.new(2015, month - 1, 1)) do
          expect(subject.submited_days_of_month(month)).to eq("15(1), 16(1), 30(1)")
        end
      end
    end

    context "when month is current" do
      let(:dates) {
        {"2015-07-30"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2015-07-15"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2015-07-16"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n  :time: '10:10'\n",
         "2015-06-14"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2015-08-17"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n"}
      }
      it "starts from today" do
        Timecop.freeze(Date.new(2015, month, 16)) do
          expect(subject.submited_days_of_month(month)).to eq("16(1), 30(1)")
        end
      end
    end

    context "when month < current_month" do
      let(:dates) {
        {"2015-06-30"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n",
         "2016-06-15"=>"---\n- :id: 65208698\n  :username: timur\n  :first_name: Timur\n"}
      }
      it "starts from today" do
        Timecop.freeze(Date.new(2015, month, 16)) do
          expect(subject.submited_days_of_month(month - 1)).to eq("15(1)")
        end
      end
    end
  end

  describe 'Calendar#submited_days_by_user' do
    let(:storage) { double('storage') }
    let(:month) { 7 }
    let(:username) { 'timur' }
    subject { described_class }
    before { allow(storage).to receive(:get_all_available_dates).and_return(dates) }

    context "when has reserved days in current month" do
      let(:dates) {
        {"2015-07-30"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-07-15"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-07-16"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n  :time: '10:10'\n",
         "2015-06-14"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-08-17"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n"}
      }
      it "works" do
        Timecop.freeze(Date.new(2015, month, 1)) do
          expect(subject.submited_days_by_user(username)).to eq("15, 16, 30")
        end
      end
    end

    context "when has reserved days in the reset of current month" do
      let(:dates) {
        {"2015-07-30"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-07-15"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-07-16"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n  :time: '10:10'\n",
         "2015-06-14"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-08-17"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n"}
      }
      it "works" do
        Timecop.freeze(Date.new(2015, month, 20)) do
          expect(subject.submited_days_by_user(username)).to eq("30")
        end
      end
    end

    context "when hasn't reserved any days in current month" do
      let(:dates) {
        {"2015-07-30"=>"---\n- :id: 65208692\n  :username: asuka\n  :first_name: Asuka\n",
         "2015-07-15"=>"---\n- :id: 65208692\n  :username: asuka\n  :first_name: Asuka\n",
         "2015-07-16"=>"---\n- :id: 65208692\n  :username: asuka\n  :first_name: Asuka\n  :time: '10:10'\n",
         "2015-06-14"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n",
         "2015-08-17"=>"---\n- :id: 65208698\n  :username: #{username}\n  :first_name: Timur\n"}
      }
      it "starts from today" do
        Timecop.freeze(Date.new(2015, month, 1)) do
          expect(subject.submited_days_by_user(username)).to eq("")
        end
      end
    end
  end
end
