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
