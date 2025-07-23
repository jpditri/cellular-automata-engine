# frozen_string_literal: true

require_relative 'terrain_cell'
require_relative 'grid/base_grid'

module Automata
  # Manages a multi-layered ecosystem with rich terrain cells
  class EcosystemGrid
    attr_reader :width, :height, :cells, :generation, :seed
    
    def initialize(width, height, seed: nil)
      @width = width
      @height = height
      @cells = {}
      @generation = 0
      @seed = seed || Random.new_seed
      @random = Random.new(@seed)
      
      # Initialize empty terrain cells
      initialize_cells
    end
    
    # Get terrain cell at coordinates
    def get(x, y)
      x, y = normalize_coordinates(x, y)
      return nil if out_of_bounds?(x, y)
      
      @cells[[x, y]]
    end
    
    # Set terrain cell at coordinates
    def set(x, y, cell)
      x, y = normalize_coordinates(x, y)
      return if out_of_bounds?(x, y)
      
      @cells[[x, y]] = cell
    end
    
    # Get all neighbors of a cell (8-way connectivity)
    def neighbors(x, y)
      [
        [x-1, y-1], [x, y-1], [x+1, y-1],
        [x-1, y],             [x+1, y],
        [x-1, y+1], [x, y+1], [x+1, y+1]
      ].select { |nx, ny| !out_of_bounds?(nx, ny) }
    end
    
    # Get neighbor cells as array
    def neighbor_cells(x, y)
      neighbors(x, y).map { |nx, ny| get(nx, ny) }.compact
    end
    
    # Iterate through all cells
    def each_cell
      @height.times do |y|
        @width.times do |x|
          yield(x, y, get(x, y))
        end
      end
    end
    
    # Generate a complete ecosystem through layered approach
    def generate_ecosystem(options = {})
      puts "🌍 Generating ecosystem (#{@width}x#{@height})..." if options[:verbose]
      
      # Layer 1: Foundation (elevation, water)
      generate_foundation(options)
      @generation += 1
      
      # Layer 2: Climate
      generate_climate(options)
      @generation += 1
      
      # Layer 3: Biomes and vegetation
      generate_biomes(options)
      @generation += 1
      
      # Layer 4: Resources
      generate_resources(options)
      @generation += 1
      
      # Layer 5: Settlements (basic placement)
      generate_settlements(options)
      @generation += 1
      
      # Layer 6: Infrastructure
      generate_infrastructure(options)
      @generation += 1
      
      # Layer 7: Special features
      generate_special_features(options)
      @generation += 1
      
      puts "✅ Ecosystem generation complete (#{@generation} layers)" if options[:verbose]
    end
    
    private
    
    def initialize_cells
      each_position do |x, y|
        @cells[[x, y]] = TerrainCell.new
      end
    end
    
    def each_position
      @height.times do |y|
        @width.times do |x|
          yield(x, y)
        end
      end
    end
    
    def normalize_coordinates(x, y)
      [x % @width, y % @height]
    end
    
    def out_of_bounds?(x, y)
      x < 0 || x >= @width || y < 0 || y >= @height
    end
    
    # Layer 1: Generate foundation terrain (elevation, water)
    def generate_foundation(options = {})
      puts "  🏔️ Generating elevation..." if options[:verbose]
      generate_elevation(options)
      
      puts "  💧 Placing water bodies..." if options[:verbose]
      generate_water_bodies(options)
      
      puts "  🌊 Simulating water flow..." if options[:verbose]
      simulate_water_flow(options)
    end
    
    def generate_elevation(options = {})
      # Use cellular automata for realistic elevation patterns
      noise_density = options[:elevation_density] || 0.4
      iterations = options[:elevation_iterations] || 3
      
      # Initial random elevation seeds
      each_position do |x, y|
        if @random.rand < noise_density
          cell = get(x, y)
          cell.elevation = @random.rand(100..255)
        end
      end
      
      # Smooth with cellular automata iterations
      iterations.times do
        new_elevations = {}
        
        each_position do |x, y|
          cell = get(x, y)
          neighbors = neighbor_cells(x, y)
          
          if neighbors.any?
            avg_elevation = neighbors.map(&:elevation).sum / neighbors.size
            # Blend current elevation with neighbor average
            new_elevations[[x, y]] = ((cell.elevation + avg_elevation) / 2).round
          else
            new_elevations[[x, y]] = cell.elevation
          end
        end
        
        # Apply new elevations
        new_elevations.each do |(x, y), elevation|
          get(x, y).elevation = elevation
        end
      end
    end
    
    def generate_water_bodies(options = {})
      # Place water in low elevation areas
      water_threshold = options[:water_threshold] || 80
      
      each_cell do |x, y, cell|
        if cell.elevation <= water_threshold
          cell.water_level = (water_threshold - cell.elevation) * 2
          cell.water_flow = :lake
        end
      end
    end
    
    def simulate_water_flow(options = {})
      # Find water that should be rivers (connected to multiple water bodies)
      each_cell do |x, y, cell|
        next unless cell.water?
        
        water_neighbors = neighbor_cells(x, y).count(&:water?)
        
        if water_neighbors >= 1 && water_neighbors <= 3
          cell.water_flow = :stream
        elsif water_neighbors >= 4
          cell.water_flow = :river
        end
      end
    end
    
    # Layer 2: Generate climate based on elevation and water
    def generate_climate(options = {})
      each_cell do |x, y, cell|
        # Temperature decreases with elevation
        base_temp = 200 - (cell.elevation * 0.5).round
        
        # Water moderates temperature
        if cell.water? || neighbor_cells(x, y).any?(&:water?)
          base_temp += 20  # Water moderates temperature
        end
        
        cell.temperature = [0, [255, base_temp].min].max
        
        # Rainfall increases near water and at moderate elevations
        base_rainfall = 100
        base_rainfall += 50 if neighbor_cells(x, y).any?(&:water?)
        base_rainfall += 30 if cell.elevation > 120 && cell.elevation < 180
        base_rainfall -= 40 if cell.elevation > 200  # Rain shadow effect
        
        cell.rainfall = [0, [255, base_rainfall].min].max
        
        # Assign climate zones
        cell.climate_zone = determine_climate_zone(cell.temperature, cell.rainfall)
      end
    end
    
    def determine_climate_zone(temperature, rainfall)
      if temperature < 80
        :arctic
      elsif temperature > 180 && rainfall < 80
        :desert
      elsif temperature > 160
        :tropical
      else
        :temperate
      end
    end
    
    # Layer 3: Generate biomes and vegetation
    def generate_biomes(options = {})
      each_cell do |x, y, cell|
        next if cell.water?
        
        # Determine biome based on climate and elevation
        cell.biome_type = determine_biome(cell)
        
        # Set vegetation based on biome and climate
        cell.vegetation_density = calculate_vegetation_density(cell)
        cell.vegetation_type = determine_vegetation_type(cell)
        
        # Set soil fertility (with water proximity bonus)
        cell.soil_fertility = calculate_soil_fertility(cell, x, y)
      end
    end
    
    def determine_biome(cell)
      return :ocean if cell.water?
      
      case cell.climate_zone
      when :arctic
        :tundra
      when :desert
        :desert
      when :tropical
        if cell.elevation > 180
          :mountain
        elsif cell.rainfall > 120
          :forest
        else
          :grassland
        end
      when :temperate
        if cell.elevation > 200
          :mountain
        elsif cell.rainfall > 140
          :forest
        else
          :grassland
        end
      else
        :grassland
      end
    end
    
    def calculate_vegetation_density(cell)
      base_density = case cell.biome_type
                     when :forest then 180
                     when :grassland then 100
                     when :desert then 20
                     when :tundra then 40
                     when :mountain then 60
                     else 50
                     end
      
      # Modify based on rainfall and temperature
      base_density += (cell.rainfall - 128) * 0.3
      base_density += (cell.temperature - 128) * 0.2 if cell.temperature > 80
      
      [0, [255, base_density].min].max.round
    end
    
    def determine_vegetation_type(cell)
      case cell.biome_type
      when :forest
        case cell.climate_zone
        when :tropical then :tropical
        when :temperate then :deciduous
        when :arctic then :coniferous
        else :deciduous
        end
      when :grassland then :grass
      when :desert then :none
      when :tundra then :shrubs
      when :mountain then :coniferous
      else :grass
      end
    end
    
    def calculate_soil_fertility(cell, x = nil, y = nil)
      base_fertility = case cell.biome_type
                       when :grassland then 150
                       when :forest then 120
                       when :desert then 30
                       when :tundra then 50
                       when :mountain then 70
                       else 100
                       end
      
      # Near water = more fertile
      if x && y && neighbor_cells(x, y).any?(&:water?)
        base_fertility += 40
      end
      
      # Moderate elevation = more fertile
      base_fertility += 20 if cell.elevation > 100 && cell.elevation < 160
      
      [0, [255, base_fertility].min].max.round
    end
    
    # Layer 4: Generate resources based on geology
    def generate_resources(options = {})
      each_cell do |x, y, cell|
        next if cell.water?
        
        # Mineral deposits more likely in mountains
        if cell.elevation > 160
          if @random.rand < 0.1  # 10% chance in mountains
            cell.mineral_deposits << [:iron, :coal, :gems, :gold].sample
          end
        end
        
        # Magical energy varies randomly but clusters
        neighbor_magic = neighbor_cells(x, y).map(&:magical_energy).sum / 8.0
        cell.magical_energy = ((cell.magical_energy + neighbor_magic) / 2 + @random.rand(-20..20)).clamp(0, 255)
      end
    end
    
    # Layer 5: Place settlements based on suitability
    def generate_settlements(options = {})
      settlement_density = options[:settlement_density] || 0.02
      
      suitable_locations = []
      each_cell do |x, y, cell|
        if cell.settlement_suitable?
          suitable_locations << [x, y, settlement_suitability_score(x, y, cell)]
        end
      end
      
      # Sort by suitability and place settlements
      suitable_locations.sort_by { |_, _, score| -score }
                        .first((suitable_locations.size * settlement_density).round)
                        .each do |x, y, _|
        place_settlement(x, y)
      end
    end
    
    def settlement_suitability_score(x, y, cell)
      score = cell.soil_fertility
      score += 50 if neighbor_cells(x, y).any?(&:water?)  # Near water
      score += cell.mineral_deposits.size * 30           # Resources
      score -= (cell.elevation - 128).abs * 0.5         # Moderate elevation preferred
      score -= cell.danger_level                         # Safety
      score
    end
    
    def place_settlement(x, y)
      cell = get(x, y)
      
      # Determine settlement size based on local conditions
      score = settlement_suitability_score(x, y, cell)
      
      if score > 200
        cell.settlement_type = :town
        cell.population_density = 150
      elsif score > 150
        cell.settlement_type = :village
        cell.population_density = 100
      elsif score > 100
        cell.settlement_type = :hamlet
        cell.population_density = 60
      else
        cell.settlement_type = :farmland
        cell.population_density = 30
      end
      
      # Add farmland around settlements
      if cell.settlement_type != :farmland
        neighbors(x, y).each do |nx, ny|
          neighbor = get(nx, ny)
          if neighbor.farmland_suitable? && neighbor.settlement_type == :none
            neighbor.settlement_type = :farmland
            neighbor.population_density = 20
          end
        end
      end
    end
    
    # Layer 6: Generate infrastructure connecting settlements
    def generate_infrastructure(options = {})
      # Simple road generation - connect nearby settlements
      settlements = []
      each_cell do |x, y, cell|
        if [:hamlet, :village, :town, :city].include?(cell.settlement_type)
          settlements << [x, y]
        end
      end
      
      # Connect each settlement to its nearest neighbor
      settlements.each do |x1, y1|
        nearest = find_nearest_settlement(x1, y1, settlements)
        if nearest
          x2, y2 = nearest
          create_road(x1, y1, x2, y2)
        end
      end
    end
    
    def find_nearest_settlement(x, y, settlements)
      settlements.reject { |sx, sy| sx == x && sy == y }
                 .min_by { |sx, sy| Math.sqrt((sx - x)**2 + (sy - y)**2) }
    end
    
    def create_road(x1, y1, x2, y2)
      # Simple line drawing for roads
      dx = (x2 - x1).abs
      dy = (y2 - y1).abs
      x, y = x1, y1
      n = 1 + dx + dy
      x_inc = (x2 > x1) ? 1 : -1
      y_inc = (y2 > y1) ? 1 : -1
      error = dx - dy
      
      dx *= 2
      dy *= 2
      
      n.times do
        cell = get(x, y)
        if cell && cell.land? && ![:hamlet, :village, :town, :city].include?(cell.settlement_type)
          cell.infrastructure << :road unless cell.infrastructure.include?(:road)
        end
        
        if error > 0
          x += x_inc
          error -= dy
        else
          y += y_inc
          error += dx
        end
      end
    end
    
    # Layer 7: Place special features
    def generate_special_features(options = {})
      feature_density = options[:feature_density] || 0.01
      
      each_cell do |x, y, cell|
        next if @random.rand > feature_density
        next if cell.water? || cell.settlement_type != :none
        
        # Different features for different terrains
        if cell.elevation > 180  # Mountains
          if @random.rand < 0.7
            cell.special_features << :dungeon
            cell.danger_level += 50
          else
            cell.special_features << :ruins
          end
        elsif cell.biome_type == :forest && cell.vegetation_density > 150
          if @random.rand < 0.5
            cell.special_features << :shrine
          else
            cell.special_features << :ruins
          end
        elsif cell.magical_energy > 180
          cell.special_features << :shrine
          cell.danger_level += 30
        end
      end
    end
  end
end