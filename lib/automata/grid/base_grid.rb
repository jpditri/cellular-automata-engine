# frozen_string_literal: true

module Automata
  module Grid
    # Abstract base class for all grid implementations
    class BaseGrid
      attr_reader :width, :height, :cells, :wrap

      def initialize(width, height, wrap: true)
        @width = width
        @height = height
        @wrap = wrap
        @cells = {}
        @generation = 0
      end

      # Get cell value at coordinates
      def get(x, y)
        x, y = normalize_coordinates(x, y) if @wrap
        return 0 if out_of_bounds?(x, y)
        
        @cells[[x, y]] || 0
      end

      # Set cell value at coordinates
      def set(x, y, value)
        x, y = normalize_coordinates(x, y) if @wrap
        return if out_of_bounds?(x, y)
        
        if value == 0
          @cells.delete([x, y])
        else
          @cells[[x, y]] = value
        end
      end

      # Get all neighbors of a cell (to be implemented by subclasses)
      def neighbors(x, y)
        raise NotImplementedError, "Subclass must implement neighbors method"
      end

      # Get neighbor values as array
      def neighbor_values(x, y)
        neighbors(x, y).map { |nx, ny| get(nx, ny) }
      end

      # Iterate through all cells
      def each_cell
        @height.times do |y|
          @width.times do |x|
            yield(x, y, get(x, y))
          end
        end
      end

      # Get all active (non-zero) cells
      def active_cells
        @cells.dup
      end

      # Clear all cells
      def clear
        @cells.clear
        @generation = 0
      end

      # Randomize grid with given density (0.0 to 1.0)
      def randomize(density: 0.5, states: [0, 1])
        clear
        each_cell do |x, y, _|
          if rand < density
            set(x, y, states.sample)
          end
        end
      end

      # Load pattern at specific position
      def load_pattern(x_offset, y_offset, pattern)
        pattern.each_with_index do |row, y|
          row.each_with_index do |value, x|
            set(x + x_offset, y + y_offset, value)
          end
        end
      end

      # Create a deep copy of the grid
      def clone
        new_grid = self.class.new(@width, @height, wrap: @wrap)
        new_grid.instance_variable_set(:@cells, @cells.dup)
        new_grid.instance_variable_set(:@generation, @generation)
        new_grid
      end

      # Convert to 2D array (for visualization)
      def to_a
        Array.new(@height) do |y|
          Array.new(@width) { |x| get(x, y) }
        end
      end

      # Get grid statistics
      def stats
        {
          width: @width,
          height: @height,
          generation: @generation,
          active_cells: @cells.size,
          density: @cells.size.to_f / (@width * @height)
        }
      end

      private

      def normalize_coordinates(x, y)
        [x % @width, y % @height]
      end

      def out_of_bounds?(x, y)
        x < 0 || x >= @width || y < 0 || y >= @height
      end
    end
  end
end