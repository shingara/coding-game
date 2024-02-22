# frozen_string_literal: true
ENV['TEST'] = 'true'
require_relative './code.rb'


RSpec.describe "#has_risk" do
  context "without my action" do
    let(:my_action) { [] }
    it 'should return the risk first block if risk on first block' do
      opponent_action = [[0,0],[0,1]]
      expect(has_risk(opponent_action, my_action)).to eq [[0,0]]
    end

    it 'should return the risk second block if risk on second block' do
      3.times.each do |i|
        3.times.each do |j|
          vector = [i, j]
          opponent_action = [
            [0+vector[0]*3,0+vector[1]*3],
            [0+vector[0]*3,2+vector[1]*3]
          ]
          expect(has_risk(opponent_action, my_action)).to eq [vector]
        end
      end
    end
  end

  context "without my action block risk" do
    it 'should not return the risk first block if risk on first block' do
      opponent_action = [[0,0],[0,1]]
      expect(has_risk(opponent_action, [[0,2]])).to eq []
    end
  end
end

RSpec.describe "#block_opponent" do

  context "without my action" do
    let(:my_action) { [] }
    it 'should return the block first block if risk on first block' do
      opponent_action = [[0,0],[0,1]]
      expect(block_opponent(opponent_action, [0,0], my_action)).to eq [[0,2]]
    end

    it 'should return the block second block if risk on second block' do
      3.times.each do |i|
        3.times.each do |j|
          vector = [i, j]
          opponent_action = [
            [0+vector[0]*3,0+vector[1]*3],
            [0+vector[0]*3,2+vector[1]*3]
          ]
          expect(block_opponent(opponent_action, vector, my_action)).to eq [[0+vector[0]*3,1+vector[1]*3]]
        end
      end
    end
  end

  context "without my action block risk" do
    it 'should return the block in the vestor where I have to be' do
      opponent_action = [[0,0],[0,1]]
      expect(block_opponent(opponent_action, [0,0], [])).to eq [[0,2]]
    end

    it 'should not return the block first block if risk on first block because I already am' do
      opponent_action = [[0,0],[0,1]]
      expect(block_opponent(opponent_action, [0,0], [[0,2]])).to eq []
    end
  end
end


RSpec.describe "#on_local" do
  it 'return the value of the local of block in the vector' do
    expect(on_local([0,0], [1,1])).to eq [3,3]
    expect(on_local([0,1], [2,1])).to eq [6,4]
  end

  it 'return [] if base empty' do
    expect(on_local([], [1,1])).to eq []
  end
end

RSpec.describe "#the_best_move" do
  let(:all_action) { [[0,0], [0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]] }
  let(:base_action) { [[0,0], [0,1], [0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]] }
  let(:vector) { [0,0] }
  let(:my_action) { [] }
  let(:opponent_action) { [] }

  context "without any action" do
    it 'should return the best move' do
      expect(the_best_move(opponent_action, base_action, my_action, all_action, vector)).to eq({
        [0,0] => 3,
        [0,1] => 2,
        [0,2] => 3,
        [1,0] => 2,
        [1,1] => 4,
        [1,2] => 2,
        [2,0] => 3,
        [2,1] => 2,
        [2,2] => 3
      })
    end
  end

  context "with a opponent action" do
    let(:opponent_action) { [[0,0]] }
    it 'should return the best move' do
      expect(the_best_move(opponent_action, base_action, my_action, all_action, vector)).to eq({
        [0,1] => 0,
        [0,2] => 1,
        [1,0] => 0,
        [1,1] => 2,
        [1,2] => 2,
        [2,0] => 1,
        [2,1] => 2,
        [2,2] => 1
      })
    end
  end

  context "with a opponent action and my action" do
    let(:opponent_action) { [[0,0]] }
    let(:my_action) { [[0,1]] }
    it 'should return the best move' do
      expect(the_best_move(opponent_action, base_action, my_action, all_action, vector)).to eq({
        [0,2] => 2,
        [1,0] => 0,
        [1,1] => 3,
        [1,2] => 2,
        [2,0] => 1,
        [2,1] => 3,
        [2,2] => 1
      })
    end
  end

  context "with a vector" do
    let(:vector) { [1,1] }
    context "with a opponent action outside" do
      let(:opponent_action) { [[0,0]] }
      it 'should return the best move by check the vector' do
        expect(the_best_move(opponent_action, base_action, my_action, all_action, vector)).to eq({
          [0,0] => 3,
          [0,1] => 2,
          [0,2] => 3,
          [1,0] => 2,
          [1,1] => 4,
          [1,2] => 2,
          [2,0] => 3,
          [2,1] => 2,
          [2,2] => 3
        })
      end
    end

    context "with a opponent action inside" do
      let(:opponent_action) { [[3,3]] }
      it 'should return the best move by check the vector' do
        expect(the_best_move(opponent_action, base_action, my_action, all_action, vector)).to eq({
        [0,1] => 0,
        [0,2] => 1,
        [1,0] => 0,
        [1,1] => 2,
        [1,2] => 2,
        [2,0] => 1,
        [2,1] => 2,
        [2,2] => 1
        })
      end
    end

    context "with a opponent action inside and my action" do
      let(:opponent_action) { [[3,3]] }
      let(:my_action) { [[3,4]] }
      it 'should return the best move by check the vector' do
        expect(the_best_move(opponent_action, base_action, my_action, all_action, vector)).to eq({
        [0,2] => 2,
        [1,0] => 0,
        [1,1] => 3,
        [1,2] => 2,
        [2,0] => 1,
        [2,1] => 3,
        [2,2] => 1
        })
      end
    end
  end
end
