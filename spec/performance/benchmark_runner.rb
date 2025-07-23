require 'benchmark/ips'
require_relative '../../lib/automata/grid/base_grid'

class BenchmarkRunner
  def run
    puts "Running performance benchmarks...\n\n"
    
    benchmark_grid_creation
    benchmark_cell_operations
    benchmark_rule_application
    benchmark_neighbor_calculations
  end
  
  private
  
  def benchmark_grid_creation
    puts "=== Grid Creation Benchmark ==="
    
    Benchmark.ips do |x|
      x.report("10x10 grid") { BaseGrid.new(10, 10) }
      x.report("100x100 grid") { BaseGrid.new(100, 100) }
      x.report("1000x1000 grid") { BaseGrid.new(1000, 1000) }
      
      x.compare!
    end
    puts "\n"
  end
  
  def benchmark_cell_operations
    puts "=== Cell Operations Benchmark ==="
    
    small_grid = BaseGrid.new(100, 100)
    large_grid = BaseGrid.new(1000, 1000)
    
    Benchmark.ips do |x|
      x.report("get_cell (100x100)") do
        100.times { small_grid.get_cell(rand(100), rand(100)) }
      end
      
      x.report("set_cell (100x100)") do
        100.times { small_grid.set_cell(rand(100), rand(100), 1) }
      end
      
      x.report("get_cell (1000x1000)") do
        100.times { large_grid.get_cell(rand(1000), rand(1000)) }
      end
      
      x.report("set_cell (1000x1000)") do
        100.times { large_grid.set_cell(rand(1000), rand(1000), 1) }
      end
      
      x.compare!
    end
    puts "\n"
  end
  
  def benchmark_rule_application
    puts "=== Rule Application Benchmark ==="
    
    conway_rules = {
      'rules' => {
        'birth' => [3],
        'survival' => [2, 3]
      }
    }
    
    # Create grids with different densities
    sparse_grid = BaseGrid.new(100, 100)
    dense_grid = BaseGrid.new(100, 100)
    
    # Seed grids
    100.times do
      sparse_grid.set_cell(rand(100), rand(100), 1)
    end
    
    5000.times do
      dense_grid.set_cell(rand(100), rand(100), 1)
    end
    
    Benchmark.ips do |x|
      x.report("Conway rules (sparse)") do
        sparse_grid.apply_rule(conway_rules)
      end
      
      x.report("Conway rules (dense)") do
        dense_grid.apply_rule(conway_rules)
      end
      
      x.compare!
    end
    puts "\n"
  end
  
  def benchmark_neighbor_calculations
    puts "=== Neighbor Calculation Benchmark ==="
    
    grid = BaseGrid.new(100, 100)
    
    Benchmark.ips do |x|
      x.report("neighbors (no wrap)") do
        grid.wrapping = false
        100.times { grid.neighbors(rand(100), rand(100)) }
      end
      
      x.report("neighbors (with wrap)") do
        grid.wrapping = true
        100.times { grid.neighbors(rand(100), rand(100)) }
      end
      
      x.report("count_neighbors") do
        100.times { grid.count_neighbors(rand(100), rand(100)) }
      end
      
      x.compare!
    end
    puts "\n"
  end
end