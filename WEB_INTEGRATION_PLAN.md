# Isomorphic Web Integration Plan - Cellular Automaton Engine

## Executive Summary
Integration of the cellular automaton engine with the existing web terminal system, enabling isomorphic execution (same code runs on server and browser) with real-time visualizations.

## Technical Architecture

### 1. Isomorphic Ruby Execution
**Technology**: Opal (Ruby-to-JavaScript transpiler)
- Compile Ruby automaton engine to JavaScript
- Share same codebase between server and browser
- Progressive enhancement: server-side fallback

### 2. WebAssembly Integration (Phase 2)
**Technology**: Ruby WASM via ruby.wasm
- Better performance for large grids
- Near-native execution speed
- Seamless integration with JavaScript

### 3. Web Terminal Visualization

#### ASCII Renderer for Terminal
```ruby
class WebTerminalRenderer < BaseRenderer
  def render_frame(grid)
    output = []
    grid.each_row do |row|
      output << row.map { |cell| cell_to_ascii(cell) }.join
    end
    { type: 'automaton_frame', data: output.join("\n") }
  end
  
  private
  def cell_to_ascii(cell)
    case cell
    when 0 then '·'
    when 1 then '█'
    else cell.to_s[0]
    end
  end
end
```

#### Canvas Renderer for Rich Visualization
```javascript
// React component for browser-side rendering
class AutomatonCanvas extends React.Component {
  componentDidMount() {
    this.ctx = this.canvas.getContext('2d');
    this.startAnimation();
  }
  
  renderGrid(grid) {
    const cellSize = this.props.cellSize || 5;
    grid.forEach((row, y) => {
      row.forEach((cell, x) => {
        this.ctx.fillStyle = this.cellColor(cell);
        this.ctx.fillRect(x * cellSize, y * cellSize, cellSize, cellSize);
      });
    });
  }
}
```

### 4. WebSocket Communication
Real-time streaming of automaton states:
```ruby
class AutomatonChannel < ApplicationCable::Channel
  def subscribed
    stream_from "automaton_#{params[:session_id]}"
  end
  
  def run_simulation(data)
    simulator = create_simulator(data['rules'], data['grid_type'])
    
    Thread.new do
      100.times do |step|
        simulator.step!
        ActionCable.server.broadcast(
          "automaton_#{params[:session_id]}",
          frame: simulator.current_frame,
          step: step
        )
        sleep(0.1)
      end
    end
  end
end
```

### 5. CLI Integration
Extend existing CLI system:
```ruby
# New commands for web terminal
./computer automaton conway --web         # Run in web terminal
./computer automaton langton --canvas     # Run with canvas viz
./computer automaton wolfram --share      # Generate shareable link
```

## Implementation Phases

### Phase 1: Basic Web Terminal Integration (Week 1)
- [ ] Create Opal configuration for automaton engine
- [ ] Implement WebTerminalRenderer
- [ ] Add automaton commands to CLI router
- [ ] Basic ASCII visualization in terminal

### Phase 2: Interactive Canvas (Week 2)
- [ ] React component for canvas rendering
- [ ] WebSocket channel for real-time updates
- [ ] Play/pause/step controls
- [ ] Speed adjustment

### Phase 3: Isomorphic Execution (Week 3)
- [ ] Full Opal compilation of engine
- [ ] Client-side rule evaluation
- [ ] Server/client mode switching
- [ ] Performance optimization

### Phase 4: Advanced Features (Week 4)
- [ ] Rule editor in browser
- [ ] Save/load simulations
- [ ] Share via URL
- [ ] Export as GIF/video

## Technical Stack

### Backend
- **Rails**: Existing framework
- **ActionCable**: WebSocket communication
- **Opal**: Ruby-to-JS transpiler
- **ActiveJob**: Background simulation processing

### Frontend
- **React**: Existing UI framework
- **Canvas API**: Grid visualization
- **Web Workers**: Offload computation
- **IndexedDB**: Client-side storage

### Build Pipeline
```javascript
// webpack.config.js additions
module.exports = {
  module: {
    rules: [
      {
        test: /\.rb$/,
        use: 'opal-webpack-loader'
      }
    ]
  },
  resolve: {
    extensions: ['.rb', '.js', '.jsx']
  }
};
```

## API Design

### REST Endpoints
```
POST   /api/automaton/create
GET    /api/automaton/:id
PUT    /api/automaton/:id/step
DELETE /api/automaton/:id
GET    /api/automaton/templates
```

### WebSocket Events
```
// Client -> Server
{ action: 'create', grid_type: 'square', size: [50, 50] }
{ action: 'set_rules', rules: [...] }
{ action: 'run', steps: 100 }
{ action: 'pause' }

// Server -> Client
{ event: 'frame', data: grid_state, step: 42 }
{ event: 'complete', total_steps: 100 }
{ event: 'error', message: 'Invalid rule syntax' }
```

## Integration Points

### 1. Web Terminal Commands
```bash
# In web terminal
automaton new --type square --size 30x30
automaton rule --add "B3/S23"  # Conway's Life notation
automaton run --steps 100
automaton export --format ascii
```

### 2. Visual Mode Toggle
```javascript
// Terminal can switch between ASCII and Canvas
terminal.setVisualizationMode('canvas');
terminal.runCommand('automaton run --visual');
```

### 3. Shareable URLs
```
https://heretical-rpg.systems/automaton/share/abc123
# Loads specific configuration and ruleset
```

## Performance Considerations

1. **Progressive Loading**: Start with server-side, switch to client when ready
2. **Lazy Compilation**: Only compile Opal modules as needed
3. **Web Workers**: Run simulations in background threads
4. **Efficient Updates**: Only send grid deltas over WebSocket
5. **Canvas Optimization**: Use offscreen canvas for large grids

## Security

- Sandboxed rule execution (no arbitrary code)
- Rate limiting on simulation requests
- Maximum grid size limits
- Resource quotas per user session

## Monitoring & Analytics

- Track popular rule sets
- Performance metrics (FPS, computation time)
- User engagement (steps run, shares created)
- Error tracking for rule compilation

## Success Metrics

1. **Performance**: 60 FPS for 100x100 grids
2. **Latency**: <50ms server response time
3. **Compatibility**: Works on 95% of modern browsers
4. **User Engagement**: Average 5+ minute sessions
5. **Sharing**: 20% of users create shareable links