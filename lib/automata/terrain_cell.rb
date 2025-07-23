# frozen_string_literal: true

module Automata
  # Represents a single cell in an ecosystem with multiple attributes
  class TerrainCell
    # Foundation attributes
    attr_accessor :elevation        # 0-255: height above sea level
    attr_accessor :water_level      # 0-255: water depth (0 = dry land)
    attr_accessor :water_flow       # Symbol: :none, :stream, :river, :lake
    
    # Climate attributes  
    attr_accessor :temperature      # 0-255: cold to hot
    attr_accessor :rainfall         # 0-255: dry to wet
    attr_accessor :climate_zone     # Symbol: :arctic, :temperate, :tropical, :desert
    
    # Biome and vegetation
    attr_accessor :biome_type       # Symbol: :ocean, :grassland, :forest, :desert, :mountain, :tundra
    attr_accessor :vegetation_density # 0-255: sparse to dense
    attr_accessor :vegetation_type  # Symbol: :none, :grass, :shrubs, :deciduous, :coniferous, :tropical
    
    # Resources and geology
    attr_accessor :soil_fertility   # 0-255: barren to fertile
    attr_accessor :mineral_deposits # Array of symbols: [:iron, :gold, :gems, :coal]
    attr_accessor :magical_energy   # 0-255: mundane to highly magical
    
    # Civilization
    attr_accessor :settlement_type  # Symbol: :none, :farmland, :hamlet, :village, :town, :city
    attr_accessor :population_density # 0-255: empty to crowded
    attr_accessor :infrastructure   # Array of symbols: [:road, :bridge, :dock, :wall]
    
    # Special features
    attr_accessor :special_features # Array of symbols: [:dungeon, :ruins, :shrine, :tower, :cave]
    attr_accessor :danger_level     # 0-255: safe to extremely dangerous
    attr_accessor :exploration_status # Symbol: :unexplored, :known, :mapped, :settled
    
    def initialize
      # Foundation defaults
      @elevation = 128        # Sea level
      @water_level = 0        # Dry land
      @water_flow = :none
      
      # Climate defaults
      @temperature = 128      # Temperate
      @rainfall = 128         # Moderate
      @climate_zone = :temperate
      
      # Biome defaults
      @biome_type = :grassland
      @vegetation_density = 64  # Light vegetation
      @vegetation_type = :grass
      
      # Resource defaults
      @soil_fertility = 128     # Average fertility
      @mineral_deposits = []
      @magical_energy = 32      # Low magic
      
      # Civilization defaults
      @settlement_type = :none
      @population_density = 0
      @infrastructure = []
      
      # Special feature defaults
      @special_features = []
      @danger_level = 32        # Relatively safe
      @exploration_status = :unexplored
    end
    
    # Check if this cell is water
    def water?
      @water_level > 0 || @water_flow != :none
    end
    
    # Check if this cell is land
    def land?
      !water?
    end
    
    # Check if this cell is suitable for settlement
    def settlement_suitable?
      land? && 
      @elevation > 64 &&      # Not too low (flood risk)
      @elevation < 200 &&     # Not too high (mountains)
      @soil_fertility > 64 && # Reasonably fertile
      @danger_level < 128     # Not too dangerous
    end
    
    # Check if this cell is suitable for farming
    def farmland_suitable?
      land? &&
      @elevation > 32 &&      # Above flood level
      @elevation < 180 &&     # Not mountainous
      @soil_fertility > 96 && # Good fertility
      @water_level == 0 &&    # Not flooded
      @temperature > 64 &&    # Not too cold
      @rainfall > 32          # Some rainfall
    end
    
    # Get the primary terrain type for display
    def primary_terrain
      return :water if water?
      return :mountain if @elevation > 200
      return :hill if @elevation > 160
      
      case @biome_type
      when :forest
        @vegetation_density > 128 ? :dense_forest : :light_forest
      when :desert
        :desert
      when :grassland
        @vegetation_density > 64 ? :grassland : :plains
      when :tundra
        :tundra
      else
        :unknown
      end
    end
    
    # Get a character representation for ASCII display
    def display_char
      # Settlement takes priority
      case @settlement_type
      when :city then return '🏰'
      when :town then return '🏘️'
      when :village then return '🏠'
      when :hamlet then return '🏡'
      when :farmland then return '🌾'
      end
      
      # Special features
      return '⚔️' if @special_features.include?(:dungeon)
      return '🏛️' if @special_features.include?(:ruins)
      return '⛩️' if @special_features.include?(:shrine)
      
      # Terrain based on biome and attributes
      return '🌊' if water? && @water_flow == :river
      return '🏞️' if water? && @water_flow == :lake
      return '💧' if water?
      return '⛰️' if @elevation > 200
      return '🗻' if @elevation > 180
      return '🌲' if @biome_type == :forest && @vegetation_density > 128
      return '🌳' if @biome_type == :forest
      return '🏜️' if @biome_type == :desert
      return '❄️' if @biome_type == :tundra
      return '🌱' if @vegetation_density > 64
      
      '·' # Default empty
    end
    
    # Get a detailed description of this cell
    def describe
      parts = []
      
      # Elevation
      if @elevation > 200
        parts << "mountainous"
      elsif @elevation > 160
        parts << "hilly"
      elsif @elevation < 64
        parts << "low-lying"
      end
      
      # Water
      if water?
        case @water_flow
        when :river then parts << "riverside"
        when :lake then parts << "lakeside"
        when :stream then parts << "by a stream"
        else parts << "waterlogged"
        end
      end
      
      # Biome
      parts << @biome_type.to_s.gsub('_', ' ')
      
      # Vegetation
      if @vegetation_density > 192
        parts << "densely vegetated"
      elsif @vegetation_density > 128
        parts << "well vegetated"
      elsif @vegetation_density > 64
        parts << "lightly vegetated"
      else
        parts << "sparse vegetation"
      end
      
      # Settlement
      unless @settlement_type == :none
        parts << "with #{@settlement_type}"
      end
      
      # Special features
      @special_features.each do |feature|
        parts << "containing #{feature.to_s.gsub('_', ' ')}"
      end
      
      parts.join(", ").capitalize
    end
    
    # Create a deep copy of this cell
    def clone
      new_cell = TerrainCell.new
      instance_variables.each do |var|
        value = instance_variable_get(var)
        new_value = value.is_a?(Array) ? value.dup : value
        new_cell.instance_variable_set(var, new_value)
      end
      new_cell
    end
    
    # Convert to hash for serialization
    def to_h
      {
        elevation: @elevation,
        water_level: @water_level,
        water_flow: @water_flow,
        temperature: @temperature,
        rainfall: @rainfall,
        climate_zone: @climate_zone,
        biome_type: @biome_type,
        vegetation_density: @vegetation_density,
        vegetation_type: @vegetation_type,
        soil_fertility: @soil_fertility,
        mineral_deposits: @mineral_deposits,
        magical_energy: @magical_energy,
        settlement_type: @settlement_type,
        population_density: @population_density,
        infrastructure: @infrastructure,
        special_features: @special_features,
        danger_level: @danger_level,
        exploration_status: @exploration_status
      }
    end
    
    # Create from hash
    def self.from_h(hash)
      cell = new
      hash.each do |key, value|
        cell.instance_variable_set("@#{key}", value)
      end
      cell
    end
  end
end