# Game of Life Simulator - Design Document

## Overview

The Game of Life simulator will be implemented as a Julia package with a modular architecture separating core simulation logic from visualization. The system will use native Julia arrays for efficient grid computation and leverage Julia's visualization ecosystem (Plots.jl with GR backend) for real-time rendering.

## Architecture

The system follows a layered architecture:

```
┌─────────────────────────────────┐
│   Interactive Interface Layer   │
│  (Controls, Event Handling)     │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   Visualization Layer           │
│  (Plots.jl rendering)           │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   Simulation Engine             │
│  (Core Game Logic)              │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   Grid State Management         │
│  (Data structures)              │
└─────────────────────────────────┘
```

## Components and Interfaces

### 1. Grid Module (`src/grid.jl`)

**Purpose:** Manages the grid state and basic operations

**Data Structure:**
```julia
struct Grid
    cells::Matrix{Bool}  # true = alive, false = dead
    rows::Int
    cols::Int
end
```

**Key Functions:**
- `Grid(rows::Int, cols::Int)` - Constructor for empty grid
- `set_cell!(grid::Grid, row::Int, col::Int, alive::Bool)` - Set individual cell state
- `get_cell(grid::Grid, row::Int, col::Int)::Bool` - Get cell state
- `randomize!(grid::Grid, probability::Float64)` - Randomly populate grid
- `clear!(grid::Grid)` - Set all cells to dead
- `copy_grid(grid::Grid)::Grid` - Create deep copy of grid

### 2. Patterns Module (`src/patterns.jl`)

**Purpose:** Provides predefined Game of Life patterns

**Pattern Definitions:**
- Patterns stored as small 2D boolean arrays
- Include: Glider, Blinker, Toad, Beacon, Pulsar, Glider Gun

**Key Functions:**
- `place_pattern!(grid::Grid, pattern::Matrix{Bool}, row::Int, col::Int)` - Place pattern at coordinates
- `get_pattern(name::Symbol)::Matrix{Bool}` - Retrieve pattern by name

**Available Patterns:**
- `:glider` - 3x3 moving pattern
- `:blinker` - 3x1 oscillator (period 2)
- `:toad` - 4x2 oscillator (period 2)
- `:beacon` - 4x4 oscillator (period 2)
- `:pulsar` - 13x13 oscillator (period 3)
- `:glider_gun` - 36x9 pattern that generates gliders

### 3. Simulation Engine (`src/simulation.jl`)

**Purpose:** Implements Game of Life rules and evolution logic

**Data Structure:**
```julia
mutable struct Simulation
    current_grid::Grid
    initial_grid::Grid  # For reset functionality
    generation::Int
end
```

**Key Functions:**
- `Simulation(grid::Grid)` - Constructor
- `count_neighbors(grid::Grid, row::Int, col::Int)::Int` - Count live neighbors (handles edge wrapping)
- `step!(sim::Simulation)` - Compute next generation
- `run!(sim::Simulation, steps::Int)` - Run multiple generations
- `reset!(sim::Simulation)` - Reset to initial state

**Algorithm:**
- Use double buffering to avoid in-place modification issues
- Implement toroidal topology (edges wrap around)
- Optimize neighbor counting with boundary checks

### 4. Visualization Module (`src/visualization.jl`)

**Purpose:** Renders grid state using Plots.jl

**Key Functions:**
- `visualize(grid::Grid; generation::Int=0)` - Create static visualization
- `create_animation(sim::Simulation, generations::Int, fps::Int)` - Generate animation
- `interactive_mode(sim::Simulation)` - Launch interactive visualization

**Visualization Design:**
- Use heatmap plot with binary colormap (black=dead, white=alive)
- Display generation counter as plot title
- Grid lines optional for smaller grids
- Configurable cell colors

### 5. File I/O Module (`src/fileio.jl`)

**Purpose:** Save and load grid configurations

**File Format:** Plain text format (RLE - Run Length Encoded or simple text)
```
# Game of Life Pattern
# Rows: 50
# Cols: 50
# Generation: 0
.O.
..O
OOO
```

**Key Functions:**
- `save_grid(grid::Grid, filename::String)` - Save grid to file
- `load_grid(filename::String)::Grid` - Load grid from file
- `validate_file(filename::String)::Bool` - Check file format validity

### 6. Interactive Controller (`src/interactive.jl`)

**Purpose:** Provides interactive controls for the simulation

**Features:**
- Keyboard controls for play/pause/step/reset
- Speed adjustment
- Pattern insertion
- Click to toggle cells (if using interactive backend)

**Key Functions:**
- `run_interactive(sim::Simulation; fps::Int=10)` - Main interactive loop
- `handle_input(sim::Simulation, key::String)` - Process user input

## Data Models

### Grid State
- Represented as `Matrix{Bool}` for memory efficiency
- Row-major ordering for cache efficiency
- Toroidal topology (edges wrap)

### Simulation State
```julia
mutable struct Simulation
    current_grid::Grid
    initial_grid::Grid
    generation::Int
end
```

## Error Handling

### Input Validation
- Grid dimensions must be positive integers between 10 and 500
- Pattern placement coordinates must be within grid bounds
- File paths must be valid and accessible
- Probability values must be between 0.0 and 1.0

### Error Types
- `DimensionError` - Invalid grid dimensions
- `BoundsError` - Pattern or cell access out of bounds
- `FileFormatError` - Invalid file format during load
- `IOError` - File system errors

### Error Recovery
- Validate all inputs before processing
- Provide clear error messages with corrective guidance
- Gracefully handle file I/O failures
- Clip out-of-bounds pattern placements rather than failing

## Testing Strategy

### Unit Tests
- Grid creation and manipulation
- Neighbor counting algorithm (including edge cases)
- Pattern placement
- Game of Life rules implementation
- File I/O operations

### Integration Tests
- Full simulation runs with known patterns
- Verify stable patterns remain stable
- Verify oscillators have correct periods
- Verify gliders move correctly

### Test Patterns
- Still lifes: Block, Beehive, Loaf
- Oscillators: Blinker, Toad, Beacon
- Spaceships: Glider
- Edge cases: Empty grid, full grid, single cell

### Performance Tests
- Benchmark grid sizes: 50x50, 100x100, 200x200
- Target: <100ms per generation for 100x100 grid
- Memory usage profiling

## Dependencies

### Required Julia Packages
- **Plots.jl** (v1.38+) - Visualization
- **GR** (backend for Plots.jl) - Fast rendering
- **Test** (stdlib) - Unit testing
- **FileIO** (optional) - Enhanced file operations

### Project Structure
```
GameOfLife/
├── Project.toml          # Package manifest
├── src/
│   ├── GameOfLife.jl     # Main module file
│   ├── grid.jl           # Grid data structure
│   ├── patterns.jl       # Pattern definitions
│   ├── simulation.jl     # Simulation engine
│   ├── visualization.jl  # Plotting functions
│   ├── fileio.jl         # Save/load functionality
│   └── interactive.jl    # Interactive controls
├── test/
│   ├── runtests.jl       # Test runner
│   ├── test_grid.jl      # Grid tests
│   ├── test_simulation.jl # Simulation tests
│   └── test_patterns.jl  # Pattern tests
└── examples/
    ├── basic_usage.jl    # Simple example
    └── patterns_demo.jl  # Pattern showcase
```

## Implementation Notes

### Performance Optimizations
- Use `@inbounds` for inner loops after bounds checking
- Pre-allocate arrays to avoid allocations in hot paths
- Consider `@simd` for neighbor counting loops
- Use `BitArray` instead of `Matrix{Bool}` for large grids (optional optimization)

### Julia-Specific Considerations
- Leverage multiple dispatch for different initialization methods
- Use `!` convention for mutating functions
- Follow Julia style guide (lowercase with underscores)
- Export public API from main module
- Use type annotations for clarity and potential performance

### Visualization Considerations
- GR backend is fastest for real-time updates
- Use `display()` for interactive environments (Jupyter, Pluto)
- Consider `Makie.jl` as alternative for more advanced interactivity
- Implement frame rate limiting to prevent excessive CPU usage
