# IMF Recruitment Directive - Cellular Automaton Engine

## Directive ID: IMF-2024-CA-001
**Priority**: High
**Resource Type**: Automated Agent Deployment

## Agent Recruitment Manifest

### Primary Agents Required

#### 1. Grid Architect Agent (Tier 3)
**Role**: Design and implement grid systems
**Capabilities**:
- Square and hexagonal grid mathematics
- Efficient sparse matrix operations
- Neighbor calculation algorithms
- Toroidal boundary conditions

#### 2. Rule Engine Agent (Tier 3)
**Role**: Build flexible rule evaluation system
**Capabilities**:
- Pattern matching algorithms
- State transition logic
- DSL parsing and compilation
- Performance optimization

#### 3. Visualization Specialist Agent (Tier 3)
**Role**: Create rendering systems
**Capabilities**:
- ASCII art generation
- Canvas API manipulation
- WebGL shader programming
- Animation timing and frames

#### 4. Isomorphic Bridge Agent (Tier 4)
**Role**: Enable server/client code sharing
**Capabilities**:
- Opal transpilation expertise
- WebAssembly compilation
- JavaScript interop
- Performance profiling

### Support Agents

#### 5. Test Automation Agent (Tier 2)
**Role**: Comprehensive test coverage
**Tasks**:
- Unit test generation
- Integration test scenarios
- Performance benchmarks
- Visual regression tests

#### 6. Documentation Agent (Tier 2)
**Role**: Technical documentation
**Tasks**:
- API documentation
- Code examples
- Tutorial creation
- Architecture diagrams

## Deployment Schedule

### Phase 1: Core Team Assembly (Immediate)
```yaml
deployment:
  - agent: grid-architect-prime
    activation: immediate
    resources: high
    
  - agent: rule-engine-master
    activation: immediate
    resources: high
    
  - agent: test-automation-unit
    activation: immediate
    resources: medium
```

### Phase 2: Visualization Team (Week 1)
```yaml
deployment:
  - agent: ascii-renderer-specialist
    activation: week_1
    dependencies: [grid-architect-prime]
    
  - agent: canvas-visualization-expert
    activation: week_1
    dependencies: [grid-architect-prime]
```

### Phase 3: Web Integration (Week 2)
```yaml
deployment:
  - agent: isomorphic-bridge-engineer
    activation: week_2
    dependencies: [rule-engine-master]
    
  - agent: websocket-communication-handler
    activation: week_2
    resources: medium
```

## Resource Allocation

### Compute Resources
- **Development Environment**: 16 vCPU, 32GB RAM
- **CI/CD Pipeline**: 8 vCPU, 16GB RAM per agent
- **Testing Grid**: 100 parallel test instances

### Agent Coordination
```ruby
# IMF Orchestration Configuration
IMF.configure do |config|
  config.project_id = "cellular-automaton-engine"
  
  config.agents = {
    grid_architect: {
      tier: 3,
      capabilities: [:mathematical_modeling, :data_structures],
      output: "lib/automata/grid/"
    },
    rule_engine: {
      tier: 3,
      capabilities: [:dsl_design, :performance_optimization],
      output: "lib/automata/rules/"
    }
  }
  
  config.coordination_strategy = :parallel_with_checkpoints
  config.communication_channel = :shared_memory
end
```

## Communication Protocol

### Inter-Agent Messaging
```json
{
  "protocol": "IMF-CAE-v1",
  "channels": {
    "architecture": "imf.cae.architecture",
    "implementation": "imf.cae.implementation",
    "testing": "imf.cae.testing",
    "integration": "imf.cae.integration"
  }
}
```

### Progress Reporting
- Hourly status updates to IMF dashboard
- Daily synthesis reports
- Blocking issue escalation within 15 minutes

## Quality Gates

### Automated Checkpoints
1. **Architecture Review**: Design patterns compliance
2. **Code Quality**: RuboCop standards adherence  
3. **Test Coverage**: Minimum 95% coverage
4. **Performance**: <10ms rule evaluation time
5. **Documentation**: 100% public API documented

## Escalation Path

1. **Agent Conflict**: Auto-mediation via IMF Resolver
2. **Resource Contention**: Dynamic reallocation
3. **Technical Blocker**: Tier 4 specialist consultation
4. **Critical Failure**: Human architect notification

## Success Metrics

- **Velocity**: 200+ story points per week
- **Quality**: Zero critical bugs in production
- **Efficiency**: 80% first-time-right code
- **Integration**: Seamless web terminal operation

## Activation Command

```bash
# Deploy IMF recruitment for Cellular Automaton Engine
./computer imf-deploy --directive IMF-2024-CA-001 --priority high

# Monitor deployment
./computer imf-status --project cellular-automaton-engine

# View agent coordination
./computer imf-dashboard --real-time
```

---

**Authorization**: IMF Core Council
**Effective Date**: Immediate
**Review Cycle**: Daily during implementation