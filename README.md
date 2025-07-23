# Cellular Automaton Game Engine

A flexible Ruby engine for creating and visualizing cellular automata on square and hexagonal grids. Build programs like Conway's Game of Life, Langton's Ant, and Wolfram's elementary cellular automata with simple rule definitions.

## Features

- **Multiple Grid Types**: Square (4/8 neighbors) and hexagonal (6 neighbors) grids
- **Simple Rule System**: Define rules as Ruby blocks or use built-in templates
- **Visualization**: Console ASCII, SDL2 graphics, or SVG export
- **Example Programs**: Conway's Game of Life, Langton's Ant, Wolfram rules
- **Interactive**: Play/pause, step through generations, adjust speed
- **Extensible**: Easy to add new grid types, rules, and renderers

## Quick Start

```ruby
# Conway's Game of Life
./bin/automata conway --size 50x50 --renderer sdl

# Langton's Ant
./bin/automata langton --size 100x100 --steps 10000

# Wolfram Rule 30
./bin/automata wolfram --rule 30 --size 200 --generations 100
```

## Custom Rules

```ruby
# Define your own cellular automaton
require 'automata'

grid = Automata::SquareGrid.new(50, 50)
rules = Automata::RuleSet.new

# Rule: A cell becomes alive if it has exactly 3 alive neighbors
rules.add_rule do |cell, neighbors|
  alive_count = neighbors.count { |n| n == 1 }
  alive_count == 3 ? 1 : 0
end

sim = Automata::Simulator.new(grid, rules)
sim.randomize(density: 0.3)
sim.run(steps: 100)
```

## Installation

```bash
gem install bundler
bundle install
```

## Requirements

- Ruby 3.0+
- SDL2 (for graphics rendering)
  - macOS: `brew install sdl2`
  - Ubuntu: `sudo apt-get install libsdl2-dev`

## Documentation

See [PLAN.md](PLAN.md) for detailed architecture and implementation plan.