# CLAUDE.md - Cellular Automata Engine

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

**Cellular Automata Engine** - Flexible Ruby engine for creating and visualizing cellular automata on square and hexagonal grids.

This is a specialized visualization and simulation package extracted from the main D&D system for focused development.

## Development Standards

**🚨 CRITICAL CONSTRAINTS:**
- **NEVER create files** unless absolutely necessary  
- **ALWAYS prefer editing** existing files
- **CLI-first approach** - All functionality must be accessible via command line
- **Maintain Ruby conventions** - Follow existing code style and patterns

## Core Architecture

### Command Line Interface
All functionality is accessible through CLI tools:
```bash
./bin/automata-generator      # Generate new automata patterns
./bin/grid-visualizer        # Visualize automata on grids  
./bin/pattern-analyzer       # Analyze automata behaviors
./bin/export-engine          # Export visualizations
```

### Grid Systems
- **Square grids**: Traditional cellular automata
- **Hexagonal grids**: More natural organic patterns
- **Configurable sizes**: From small demos to large simulations

### Rule Systems  
- **Conway's Game of Life**: Classic implementation
- **Custom rules**: User-defined cellular behaviors
- **Probabilistic rules**: Randomized cellular evolution

## Integration Points

### With Main D&D System
- **World generation**: Create natural terrain features
- **Population dynamics**: Model settlement growth
- **Magic effects**: Visualize spell propagation
- **Weather patterns**: Generate atmospheric effects

### With Other Packages
- **Media Assets**: Export visualizations to CDN
- **AI Research**: Provide simulation data for analysis
- **System Operations**: Performance monitoring and deployment

## Development Workflow

### Adding New Features
1. **Create CLI tool** in `bin/` directory
2. **Implement core logic** in `lib/` directory  
3. **Add tests** following existing patterns
4. **Update documentation** in README.md
5. **Test integration** with main system

### Testing
```bash
./bin/test-runner              # Run all tests
./bin/integration-test         # Test with main system
./bin/performance-benchmark    # Performance validation
```

### Performance Considerations
- **Memory efficiency**: Large grids require careful memory management
- **Computation speed**: Optimize hot paths in cellular updates
- **Visualization**: Balance quality vs. render speed
- **Export formats**: Support multiple output formats

## Package Dependencies

### External Dependencies
- Ruby 3.4+ for modern language features
- RMagick or similar for image generation
- JSON for configuration and export formats

### Internal Dependencies  
- **Unified Development Toolkit**: CLI framework and shared utilities
- **Media Assets CDN**: Asset hosting and optimization
- **System Operations**: Deployment and monitoring

## Configuration

### Development Setup
```bash
bundle install                 # Install dependencies
./bin/setup-development       # Initialize development environment
./bin/validate-installation   # Verify setup
```

### Runtime Configuration
- `config/automata.yml` - Default automata rules and parameters
- `config/grids.yml` - Grid size and type configurations  
- `config/export.yml` - Output format and quality settings

## Best Practices

### Code Organization
- **Separate concerns**: Grid logic, rules engine, visualization
- **Modular design**: Each automata type in separate module
- **Clean interfaces**: CLI tools use consistent argument patterns
- **Error handling**: Graceful degradation for invalid configurations

### Performance
- **Lazy evaluation**: Don't compute more than necessary
- **Caching**: Store expensive calculations
- **Parallel processing**: Use multiple cores for large grids
- **Memory management**: Clean up large objects promptly

### Testing Strategy
- **Unit tests**: Each component tested independently
- **Integration tests**: Verify CLI tools work correctly  
- **Performance tests**: Ensure acceptable speed on large grids
- **Visual tests**: Validate output images match expectations

## CLI Tool Standards

All CLI tools in this package follow these conventions:

### Standard Arguments
```bash
--grid-size SIZE              # Grid dimensions (e.g., 100x100)
--grid-type TYPE              # square, hexagonal
--rules RULESET               # conway, custom, probabilistic
--iterations COUNT            # Number of simulation steps
--output-format FORMAT        # png, svg, json, ascii
--verbose                     # Detailed logging
--help                        # Usage information
```

### Error Handling
- **Input validation**: Check all parameters before processing
- **Graceful failures**: Provide helpful error messages
- **Recovery options**: Suggest fixes for common problems
- **Exit codes**: Standard codes for different error types

### Output Standards
- **Consistent formatting**: All tools use similar output style
- **Progress indicators**: Show status for long-running operations
- **Result summaries**: Brief reports of what was accomplished
- **File locations**: Always report where output files were saved

## Integration with Main System

### D&D Campaign Integration
The cellular automata engine enhances D&D campaigns by:
- **Terrain generation**: Create realistic landforms and biomes
- **Settlement evolution**: Model how towns and cities grow over time
- **Magic visualization**: Show spell effects and magical field interactions
- **Combat dynamics**: Visualize battlefield conditions and troop movements

### Usage Patterns
```bash
# Generate terrain for new campaign region
./bin/terrain-generator --size 500x500 --biome forest --output campaign-maps/

# Model population growth for settlement
./bin/population-dynamics --settlement village --years 50 --export json

# Visualize spell effect propagation  
./bin/magic-visualizer --spell fireball --radius 20 --output spell-effects/
```

This package maintains the CLI-first philosophy while providing powerful visualization capabilities for both D&D gaming and general cellular automata research.