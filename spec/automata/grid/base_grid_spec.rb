require 'spec_helper'

RSpec.describe BaseGrid do
  let(:width) { 10 }
  let(:height) { 10 }
  subject(:grid) { described_class.new(width, height) }

  describe '#initialize' do
    it 'creates a grid with specified dimensions' do
      expect(grid.width).to eq(width)
      expect(grid.height).to eq(height)
    end

    it 'initializes all cells to 0' do
      grid.each_cell do |x, y, value|
        expect(value).to eq(0)
      end
    end
  end

  describe '#get_cell and #set_cell' do
    it 'sets and gets cell values' do
      grid.set_cell(5, 5, 1)
      expect(grid.get_cell(5, 5)).to eq(1)
    end

    it 'handles boundary conditions' do
      expect { grid.get_cell(-1, 0) }.not_to raise_error
      expect { grid.get_cell(width, 0) }.not_to raise_error
      expect { grid.get_cell(0, -1) }.not_to raise_error
      expect { grid.get_cell(0, height) }.not_to raise_error
    end
  end

  describe '#neighbors' do
    context 'with Moore neighborhood' do
      it 'returns 8 neighbors for center cells' do
        neighbors = grid.neighbors(5, 5)
        expect(neighbors.count).to eq(8)
      end

      it 'returns correct neighbor positions' do
        neighbors = grid.neighbors(5, 5)
        expected = [
          [4, 4], [5, 4], [6, 4],
          [4, 5],         [6, 5],
          [4, 6], [5, 6], [6, 6]
        ]
        expect(neighbors.map { |n| n[:position] }).to match_array(expected)
      end
    end

    context 'with edge wrapping' do
      it 'wraps around edges when enabled' do
        grid.wrapping = true
        neighbors = grid.neighbors(0, 0)
        expect(neighbors.count).to eq(8)
        
        # Check that we get wrapped positions
        positions = neighbors.map { |n| n[:position] }
        expect(positions).to include([width - 1, height - 1])
      end
    end
  end

  describe '#apply_rule' do
    let(:conway_rules) do
      {
        'rules' => {
          'birth' => [3],
          'survival' => [2, 3]
        }
      }
    end

    it 'applies Conway rules correctly' do
      # Set up a blinker pattern
      grid.set_cell(4, 5, 1)
      grid.set_cell(5, 5, 1)
      grid.set_cell(6, 5, 1)

      grid.apply_rule(conway_rules)

      # Should rotate to vertical
      expect(grid.get_cell(5, 4)).to eq(1)
      expect(grid.get_cell(5, 5)).to eq(1)
      expect(grid.get_cell(5, 6)).to eq(1)
      expect(grid.get_cell(4, 5)).to eq(0)
      expect(grid.get_cell(6, 5)).to eq(0)
    end
  end

  describe '#to_array' do
    it 'exports grid as 2D array' do
      grid.set_cell(0, 0, 1)
      grid.set_cell(9, 9, 1)

      array = grid.to_array
      expect(array).to be_a(Array)
      expect(array.length).to eq(height)
      expect(array[0].length).to eq(width)
      expect(array[0][0]).to eq(1)
      expect(array[9][9]).to eq(1)
    end
  end

  describe '#count_living' do
    it 'counts living cells' do
      expect(grid.count_living).to eq(0)

      grid.set_cell(1, 1, 1)
      grid.set_cell(2, 2, 1)
      grid.set_cell(3, 3, 1)

      expect(grid.count_living).to eq(3)
    end
  end

  describe '#clear' do
    it 'resets all cells to 0' do
      grid.set_cell(5, 5, 1)
      grid.set_cell(3, 3, 1)
      
      grid.clear
      
      grid.each_cell do |x, y, value|
        expect(value).to eq(0)
      end
    end
  end
end