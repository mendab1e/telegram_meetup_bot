require 'spec_helper'
require 'date'

RSpec.describe TelegramMeetupBot::ParamsParser do
  describe '#parse_date' do
    context 'fulldate' do
      let(:dates) { %w(3.02.07 3.2.07 03.02.07 03.2.07) }

      it 'works' do
        dates.each do |date|
          expect(described_class.new(date).parse_date).to eq(Date.parse('2007-02-03'))
        end
      end
    end

    context 'day with month' do
      let(:dates) { %w(3.02 3.2 03.02 03.2) }
      let(:year) { Date.today.year }

      it 'works' do
        dates.each do |date|
          expect(described_class.new(date).parse_date).to eq(Date.parse("#{year}-02-03"))
        end
      end
    end

    context 'only day' do
      let(:dates) { %w(3 03) }

      it 'works' do
        dates.each do |date|
          expect(described_class.new(date).parse_date).to eq(Date.parse("03"))
        end
      end
    end

    context 'wrong format' do
      let(:dates) { %w(abc 3.02.2007 3.02.7 2007.02.03 3-02-07 32.03.07 32 3..07 .02.07 3.02.) }

      it 'returns nil' do
        dates.each do |date|
          expect(described_class.new(date).parse_date).to eq(nil)
        end
      end
    end
  end

  describe '#parse_time' do
    context 'correct' do
      let(:time) { %w(01:05) }

      it 'works' do
        time.each do |date|
          expect(described_class.new(date).parse_time).to eq('01:05')
        end
      end
    end

    context 'wrong_format' do
      let(:time) { %w(abc 25:05 01:61 -3) }

      it 'works' do
        time.each do |date|
          expect(described_class.new(date).parse_time).to eq(nil)
        end
      end
    end
  end

  describe '#parse_month' do
    context 'correct' do
      let(:months) { %w(01 1) }

      it 'works' do
        months.each do |date|
          expect(described_class.new(date).parse_month).to eq(1)
        end
      end
    end

    context 'wrong_format' do
      let(:months) { %w(abc 13 0) }

      it 'works' do
        months.each do |date|
          expect(described_class.new(date).parse_month).to eq(nil)
        end
      end
    end
  end
end
