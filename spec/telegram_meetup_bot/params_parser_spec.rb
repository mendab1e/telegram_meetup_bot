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
      let(:dates) { %w(abc 3.02.2007 3.02.7 2007.02.03 3-02-07 32.03.07 32) }

      it 'returns nil' do
        dates.each do |date|
          expect(described_class.new(date).parse_date).to eq(nil)
        end
      end
    end
  end
end
