# Game of Life - Julia Implementation

A complete implementation of Conway's Game of Life cellular automaton in Julia, featuring simulation engine, visualization, predefined patterns, file I/O, and interactive controls.

## Features

- **Grid Management**: Flexible grid sizes (10x10 to 500x500)
- **Simulation Engine**: Efficient implementation of Conway's Game of Life rules with toroidal topology
- **Predefined Patterns**: Glider, Blinker, Toad, Beacon, Pulsar, and Gosper Glider Gun
- **Visualization**: Real-time visualization using Plots.jl with heatmap display
- **File I/O**: Save and load grid configurations
- **Interactive Mode**: Keyboard controls for play/pause, step, reset, and speed adjustment
- **Comprehensive Tests**: Full test suite covering all functionality

## Installation

1. Make sure you have Julia installed (version 1.6 or higher)
2. Clone or download this repository
3. Navigate to the project directory
4. Start Julia and activate the project:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()  # Install dependencies
```

## Quick Start

```julia
using GameOfLife

# Create a grid and add a glider pattern
grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 10, 10)

# Create and run simulation
sim = Simulation(grid)
run_interactive(sim, fps=10, auto_start=true)
```

## Usage Examples

### Basic Grid Operations

```julia
# Create a grid with default size (50x50)
grid = Grid()

# Create a custom-sized grid
grid = Grid(100, 100)

# Set individual cells
set_cell!(grid, 25, 25, true)  # Set cell to alive
set_cell!(grid, 25, 26, false) # Set cell to dead

# Randomly populate grid
randomize!(grid, 0.3)  # 30% of cells will be alive

# Clear all cells
clear!(grid)
```

### Using Patterns

```julia
# Available patterns: :glider, :blinker, :toad, :beacon, :pulsar, :glider_gun
grid = Grid(50, 50)

# Get and place a pattern
glider = get_pattern(:glider)
place_pattern!(grid, glider, 20, 20)

# Place multiple patterns
place_pattern!(grid, get_pattern(:blinker), 10, 10)
place_pattern!(grid, get_pattern(:toad), 30, 30)
```

### Running Simulations

```julia
# Create simulation
sim = Simulation(grid)

# Advance by single step
step!(sim)

# Run multiple generations
run!(sim, 100)

# Reset to initial state
reset!(sim)

# Check current generation
println("Generation: ", sim.generation)
```

### Visualization

```julia
# Static visualization
p = visualize(sim.current_grid, generation=sim.generation)
display(p)

# Create animated GIF
create_animation(sim, 50, 10, filename="simulation.gif")

# Interactive mode (continuous)
interactive_mode(sim, fps=15)
```

### File I/O

```julia
# Save grid to file
save_grid(grid, "my_pattern.txt")

# Load grid from file
loaded_grid = load_grid("my_pattern.txt")

# Validate file format
if validate_file("pattern.txt")
    grid = load_grid("pattern.txt")
end
```

### Interactive Controls

```julia
# Run with interactive controls
run_interactive(sim, fps=10, auto_start=true)

# Controls:
# - Enter/Return: Start/Pause
# - s: Single step
# - r: Reset
# - c: Clear
# - +: Increase speed
# - -: Decrease speed
# - q: Quit
```

## Running Tests

```julia
using Pkg
Pkg.activate(".")
Pkg.test()
```

Or run tests directly:

```julia
include("test/runtests.jl")
```

## Examples

Two example scripts are provided in the `examples/` directory:

1. **basic_usage.jl** - Demonstrates core functionality
2. **patterns_demo.jl** - Showcases all predefined patterns

Run them with:

```julia
include("examples/basic_usage.jl")
include("examples/patterns_demo.jl")
```

## Project Structure

```
GameOfLife/
├── Project.toml          # Package manifest
├── README.md             # This file
├── src/
│   ├── GameOfLife.jl     # Main module
│   ├── grid.jl           # Grid data structure
│   ├── patterns.jl       # Pattern definitions
│   ├── simulation.jl     # Simulation engine
│   ├── visualization.jl  # Plotting functions
│   ├── fileio.jl         # Save/load functionality
│   └── interactive.jl    # Interactive controls
├── test/
│   ├── runtests.jl       # Test runner
│   ├── test_grid.jl      # Grid tests
│   ├── test_patterns.jl  # Pattern tests
│   ├── test_simulation.jl # Simulation tests
│   └── test_fileio.jl    # File I/O tests
└── examples/
    ├── basic_usage.jl    # Basic example
    └── patterns_demo.jl  # Pattern showcase
```

## Conway's Game of Life Rules

1. Any live cell with fewer than 2 live neighbors dies (underpopulation)
2. Any live cell with 2 or 3 live neighbors survives
3. Any live cell with more than 3 live neighbors dies (overpopulation)
4. Any dead cell with exactly 3 live neighbors becomes alive (reproduction)

## Performance

- Supports grids up to 500x500 cells
- Computes each generation in < 100ms for 100x100 grids
- Uses efficient double buffering for state updates
- Toroidal topology (edges wrap around)

## Dependencies

- Julia 1.6+
- Plots.jl (for visualization)
- GR backend (automatically installed with Plots.jl)

## License

This is an educational project demonstrating Julia programming and cellular automata.

## Contributing

Feel free to experiment with the code, add new patterns, or optimize the simulation engine!

## Learn More

- [Conway's Game of Life - Wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
- [Julia Programming Language](https://julialang.org/)
- [Plots.jl Documentation](https://docs.juliaplots.org/)
