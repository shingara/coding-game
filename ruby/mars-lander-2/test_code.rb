# frozen_string_literal: true

ENV['TEST'] = 'true'
require_relative 'code'

RSpec.describe ZoneToLand do
  describe '.process' do
    it 'returns the stable lands' do
      lands = [
        Land.new(0, 0),
        Land.new(1, 1),
        Land.new(2, 1),
        Land.new(3, 2)
      ]
      expect(ZoneToLand.process(lands)).to eq(Zone.new(lands[1], lands[2]))
    end
  end
end

RSpec.describe Lander do

  let(:lander) { Lander.new(0, 0, 0, 0, 0, 0, 0) }
  let(:landing_zone) { Zone.new(Land.new(2, 3), Land.new(4, 3)) }

  describe '#in_wrong_direction' do
    describe 'lander not move' do
      describe 'outside the landing zone' do
        before do
          lander.x = 0
          lander.hs = 0
        end
        it 'returns true' do
          expect(lander.in_wrong_direction(landing_zone)).to be true
        end
      end

      describe 'inside the landing zone' do
        before do
          lander.x = 3
        end
        it 'returns true' do
          expect(lander.in_wrong_direction(landing_zone)).to be false
        end
      end
    end

    describe 'lander go to right' do
      before do
        lander.x = 0
        lander.hs = 2
      end
      it 'returns false' do
        expect(lander.in_wrong_direction(landing_zone)).to be false
      end
    end

    describe 'lander go to left' do
      before do
        lander.x = 0
        lander.hs = -1
      end
      it 'returns true' do
        expect(lander.in_wrong_direction(landing_zone)).to be true
      end
    end
  end


  describe '#time_to_go_horizontal' do

    context 'lander go to wrong direction' do
      before do
        lander.x = 10
        lander.hs = 5
      end

      it 'returns 1000' do
        expect(lander.time_to_go_horizontal(landing_zone)).to be == 1000
      end
    end

    context 'lander go to right direction' do
      it 'return time to go to the landing zone' do
        {
          [0, 2] => 1,
          [0, 4] => 0.5,
          [-10, 2] => 6,
        }.each do |d, r|
          lander.x = d[0]
          lander.hs = d[1]
          expect(lander.time_to_go_horizontal(landing_zone)).to be == r
        end
      end
    end

    context 'lander not move' do
      before do
        lander.x = 0
        lander.hs = 0
      end
      it 'return 1000' do
        expect(lander.time_to_go_horizontal(landing_zone)).to be == 1000
      end
    end
  end

  describe '#go_to' do
    describe 'landing_zone at right' do
      it 'go to to' do
        expect(lander.go_to(landing_zone)).to be == '0 3'
      end
    end
  end
end
