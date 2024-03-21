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

  describe '#in_wrong_direction?' do
    describe 'lander not move' do
      describe 'outside the landing zone' do
        before do
          lander.x = 0
          lander.hs = -1
        end
        it 'returns true' do
          expect(lander.in_wrong_direction?(landing_zone)).to be true
        end
      end

      describe 'inside the landing zone' do
        before do
          lander.x = 3
        end
        it 'returns true' do
          expect(lander.in_wrong_direction?(landing_zone)).to be false
        end
      end
    end

    describe 'lander go to right' do
      before do
        lander.x = 0
        lander.hs = 2
      end
      it 'returns false' do
        expect(lander.in_wrong_direction?(landing_zone)).to be false
      end
    end

    describe 'lander go to left' do
      before do
        lander.x = 0
        lander.hs = -1
      end
      it 'returns true' do
        expect(lander.in_wrong_direction?(landing_zone)).to be true
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
          [0, 2] => 2,
          [0, 4] => 1,
          [-10, 2] => 7,
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

  describe '#time_to_go_vertical' do
    before do
      lander.x = -10
      lander.hs = 2
    end

    context 'lander go to wrong direction' do
      before do
        lander.y = 10
        lander.vs = 5
      end

      it 'returns 1000' do
        expect(lander.time_to_go_vertical(landing_zone)).to be == (10-3).to_f/5
      end
    end
  end

  describe "#position_to_land_x" do
    before do
      lander.x = 10
      lander.hs = 2
      expect(lander).to receive(:min_time_to_go).with(landing_zone).and_return(3)
    end
    it 'returns 10' do
      expect(lander.position_to_land_x(landing_zone)).to be == 10 + 3*2
    end
  end

  describe '#min_time_to_go' do
    context "same time both" do
      before do
        lander.x = 10
        lander.y = 10
        lander.hs = 2
        lander.vs = 2
      end
      # Go do 2-3 / 3
      # time to go down (y - ly) / vs => (10 - 3) / 2
      # time to go right (x - lx) / hs => (10 - 3) / 2
      # get the lowest
      it 'returns 1000' do
        expect(lander.min_time_to_go(landing_zone)).to be == 7/2.to_f
      end
    end
  end

  describe '#get_in_zone?' do
    before do
      lander.x = 10
      lander.y = 10
      lander.hs = 2
      lander.vs = 2
    end
    it 'returns false' do
      expect(lander.get_in_zone?(landing_zone)).to be false
    end
  end

  describe '#go_to' do
    describe 'landing_zone at right' do
      it 'go to to' do
        expect(lander.go_to(landing_zone)).to be == '0 4'
      end
    end
  end

  describe '#on_top_of_zone' do
    context "on top of the zone" do
      before do
        lander.x = rand(landing_zone.land1.x..landing_zone.land2.x)
      end
      it 'return true' do
        expect(lander.on_top_of_zone?(landing_zone)).to be true
      end
    end
    context 'right of the zone' do
      before do
        lander.x = landing_zone.land2.x + 1
      end
      it 'return false' do
        expect(lander.on_top_of_zone?(landing_zone)).to be false
      end
    end
    context 'left of the zone' do
      before do
        lander.x = landing_zone.land1.x - 1
      end
      it 'return false' do
        expect(lander.on_top_of_zone?(landing_zone)).to be false
      end
    end
  end


  describe '#go_to_fast_horizontaly?' do
    context 'with a high speed' do
      before do
        lander.hs = 5*MAX_DX
      end
      it' return true' do
        expect(lander.go_to_fast_horizontaly?).to be true
      end
    end
    context 'with a low speed' do
      before do
        lander.hs = 2*MAX_DX
      end
      it' return false' do
        expect(lander.go_to_fast_horizontaly?).to be false
      end
    end
  end

  describe '#go_to_slow_horizontaly?' do
    context 'with a high speed' do
      before do
        lander.hs = 3*MAX_DX
      end
      it' return false' do
        expect(lander.go_to_slow_horizontaly?).to be false
      end
    end
    context 'with a low speed' do
      before do
        lander.hs = 1*MAX_DX
      end
      it' return true' do
        expect(lander.go_to_slow_horizontaly?).to be true
      end
    end
  end

  describe '#angle_to_aim(zone)' do
    context 'with a zone at right' do
      before do
        lander.x = landing_zone.land1.x - 1
      end
      it 'return speed to aim to right' do
        expect(lander.angle_to_aim(landing_zone)).to be == -34
      end
    end
    context 'with a zone at left' do
      before do
        lander.x = landing_zone.land2.x + 1
      end
      it 'return speed to aim to left' do
        expect(lander.angle_to_aim(landing_zone)).to be == 34
      end
    end
  end

  describe '#angle_to_slow' do
    before do
      lander.hs = 2
      lander.vs = 3
    end

    it 'return the angle to slow' do
      expect(lander.angle_to_slow).to be == 33
    end

  end
end
