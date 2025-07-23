# Cellular Automaton Game Engine Plan

## Overview
A Ruby-based cellular automaton engine supporting both square and hexagonal grids, with a simple rule system for creating programs like Langton's Ant, Conway's Game of Life, and Wolfram's elementary cellular automata.

## Core Architecture

### 1. Grid System
- **BaseGrid** - Abstract grid interface
  - `SquareGrid` - Traditional 2D square grid with 4/8 neighbors
  - `HexGrid` - Hexagonal grid with 6 neighbors
- Cell states: integers (0-255) for flexibility
- Toroidal wrapping option (edges connect)
- Efficient sparse representation for large grids

### 2. Rule Engine
- **Rule** class - Defines state transitions
  - Pattern matching on neighborhoods
  - State transition functions
  - Support for probabilistic rules
- **RuleSet** - Collection of rules with priority
- Built-in rule templates:
  - Elementary CA (Wolfram rules 0-255)
  - Totalistic rules (sum of neighbors)
  - Pattern-based rules

### 3. Simulation Engine
- **Simulator** - Core execution loop
  - Step-by-step execution
  - Batch processing for performance
  - History tracking for reversibility
- **Observer** pattern for visualization hooks

### 4. Visualization Layer
- **Renderer** - Abstract rendering interface
  - `ConsoleRenderer` - ASCII art output
  - `SDLRenderer` - SDL2 graphics (via ruby-sdl2)
  - `SVGRenderer` - Export to SVG
- Color mapping for cell states
- Zoom/pan controls
- Animation speed control

### 5. Program Examples

#### Conway's Game of Life
```ruby
rules = RuleSet.new
rules.add_rule do |cell, neighbors|
  alive_count = neighbors.count { |n| n == 1 }
  if cell == 1
    alive_count == 2 || alive_count == 3 ? 1 : 0
  else
    alive_count == 3 ? 1 : 0
  end
end
```

#### Langton's Ant
```ruby
class Ant
  attr_accessor :x, :y, :direction
  
  def turn_right
    @direction = (@direction + 1) % 4
  end
  
  def turn_left
    @direction = (@direction - 1) % 4
  end
end

rules.add_rule do |cell, neighbors, context|
  ant = context[:ant]
  if ant.x == context[:x] && ant.y == context[:y]
    if cell == 0
      ant.turn_right
      1
    else
      ant.turn_left
      0
    end
  else
    cell
  end
end
```

#### Wolfram Rule 30
```ruby
rules = RuleSet.elementary(30)  # Built-in helper
```

### 6. Interactive Rule Editor
- DSL for rule definition
- Visual rule builder
- Live preview
- Save/load rule sets as YAML/JSON

## Implementation Phases

### Phase 1: Core Engine (Week 1)
- BaseGrid, SquareGrid implementation
- Basic Rule and RuleSet classes
- Simple Simulator with step execution
- ConsoleRenderer for testing

### Phase 2: Examples & Visualization (Week 2)
- Implement Conway's Game of Life
- Implement Langton's Ant
- Add SDL2 renderer
- Basic controls (play/pause/step/speed)

### Phase 3: Advanced Features (Week 3)
- HexGrid implementation
- Wolfram elementary CA
- Rule editor DSL
- Performance optimizations

### Phase 4: Polish & Extensions (Week 4)
- Interactive rule builder UI
- More example programs
- Export capabilities (GIF, video)
- Documentation and tutorials

## Technical Stack
- Ruby 3.x
- SDL2 for graphics (via ruby-sdl2 gem)
- Optional: Gosu for alternative graphics
- Testing: RSpec
- CLI: Thor

## Directory Structure
```
cellular-automata-engine/
├── bin/
│   └── automata              # Main executable
├── lib/
│   ├── automata/
│   │   ├── grid/
│   │   │   ├── base_grid.rb
│   │   │   ├── square_grid.rb
│   │   │   └── hex_grid.rb
│   │   ├── rules/
│   │   │   ├── rule.rb
│   │   │   ├── rule_set.rb
│   │   │   └── templates/
│   │   ├── simulation/
│   │   │   ├── simulator.rb
│   │   │   └── history.rb
│   │   ├── rendering/
│   │   │   ├── base_renderer.rb
│   │   │   ├── console_renderer.rb
│   │   │   └── sdl_renderer.rb
│   │   └── programs/
│   │       ├── conway.rb
│   │       ├── langtons_ant.rb
│   │       └── wolfram.rb
│   └── automata.rb
├── examples/
├── spec/
└── README.md
```

## Usage Example
```ruby
#!/usr/bin/env ruby
require 'automata'

# Create a 50x50 square grid
grid = Automata::SquareGrid.new(50, 50)

# Load Conway's Game of Life rules
rules = Automata::Programs::Conway.rules

# Create simulator
sim = Automata::Simulator.new(grid, rules)

# Initialize with a glider pattern
sim.set_pattern(10, 10, :glider)

# Run with SDL visualization
renderer = Automata::SDLRenderer.new(sim)
renderer.run(fps: 10)
```

## Key Design Decisions
1. **Integer cell states** - More flexible than boolean
2. **Rule priority** - Allows complex rule combinations
3. **Sparse grid storage** - Efficient for large, mostly empty grids
4. **Plugin architecture** - Easy to add new grid types, rules, renderers
5. **Pure Ruby first** - Optimize later if needed

## Future Extensions
- 3D grids
- Network/graph-based automata
- GPU acceleration (via OpenCL)
- Web interface (via Opal/WebAssembly)
- Rule learning from patterns