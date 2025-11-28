# Quick Start Guide - Game of Life in Julia

## Prerequisites

- Julia 1.6 or higher installed ([Download here](https://julialang.org/downloads/))
- Windows/Linux/Mac terminal or command prompt

## Installation & Setup

### 1. Navigate to the project directory

```bash
cd path/to/GameOfLife
```

### 2. Install dependencies

```bash
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

This will install Plots.jl and all required packages (takes 2-3 minutes first time).

## Running the Project

### Option 1: Run the Demo Script (Easiest)

```bash
julia --project=. demo.jl
```

This will:
- Create a 50x50 grid
- Place a glider pattern
- Show visualizations step by step
- Let you advance through generations by pressing Enter

### Option 2: Run Example Scripts

**Basic Usage:**
```bash
julia --project=. examples/basic_usage.jl
```

**Pattern Showcase:**
```bash
julia --project=. examples/patterns_demo.jl
```

### Option 3: Interactive Julia REPL

Start Julia with the project:
```bash
julia --project=.
```

Then run these commands:

```julia
# Load the module
using GameOfLife

# Create a grid and add a glider
grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 20, 20)

# Create and run simulation
sim = Simulation(grid)

# Visualize current state
visualize(sim.current_grid, generation=sim.generation)

# Advance one generation
step!(sim)
visualize(sim.current_grid, generation=sim.generation)

# Run multiple generations
run!(sim, 10)
visualize(sim.current_grid, generation=sim.generation)

# Run in auto mode (continuous)
run_interactive(sim, fps=10, auto_start=true)
```

### Option 4: Create Your Own Patterns

```julia
using GameOfLife

# Create a grid
grid = Grid(100, 100)

# Randomly populate it
randomize!(grid, 0.3)  # 30% alive

# Or place multiple patterns
place_pattern!(grid, get_pattern(:glider), 10, 10)
place_pattern!(grid, get_pattern(:pulsar), 50, 50)
place_pattern!(grid, get_pattern(:glider_gun), 20, 60)

# Run simulation
sim = Simulation(grid)
run_interactive(sim, fps=15, auto_start=true)
```

## Available Patterns

- `:glider` - Small spaceship that moves diagonally
- `:blinker` - Smallest oscillator (period 2)
- `:toad` - Period-2 oscillator
- `:beacon` - Period-2 oscillator
- `:pulsar` - Large period-3 oscillator
- `:glider_gun` - Generates gliders indefinitely

## Creating Animations

```julia
using GameOfLife

grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 10, 10)
sim = Simulation(grid)

# Create a GIF animation
create_animation(sim, 50, 10, filename="my_simulation.gif")
```

This creates a GIF with 50 generations at 10 FPS.

## Saving and Loading Patterns

```julia
# Save your grid
save_grid(grid, "my_pattern.txt")

# Load it later
loaded_grid = load_grid("my_pattern.txt")
sim = Simulation(loaded_grid)
```

## Running Tests

```bash
julia --project=. test/runtests.jl
```

Or from Julia REPL:
```julia
using Pkg
Pkg.test()
```

## Troubleshooting

### "Package not found" error
Run: `julia --project=. -e "using Pkg; Pkg.instantiate()"`

### Visualization not showing
Make sure you're running in an environment that supports graphics (not headless terminal).

### Slow performance
- Reduce grid size: `Grid(30, 30)` instead of `Grid(100, 100)`
- Lower FPS: `run_interactive(sim, fps=5)`

## Next Steps

1. Experiment with different patterns
2. Try creating your own patterns by manually setting cells
3. Adjust grid sizes and simulation speeds
4. Create animations of interesting patterns
5. Explore the source code in `src/` directory

## Quick Commands Reference

```julia
# Grid operations
grid = Grid(50, 50)              # Create grid
set_cell!(grid, 10, 10, true)    # Set cell alive
randomize!(grid, 0.3)            # Random 30% alive
clear!(grid)                     # Clear all cells

# Patterns
place_pattern!(grid, get_pattern(:glider), 20, 20)

# Simulation
sim = Simulation(grid)           # Create simulation
step!(sim)                       # Advance 1 generation
run!(sim, 100)                   # Run 100 generations
reset!(sim)                      # Reset to initial state

# Visualization
visualize(sim.current_grid)      # Show current state
run_interactive(sim, fps=10, auto_start=true)  # Auto run

# File I/O
save_grid(grid, "pattern.txt")   # Save
grid = load_grid("pattern.txt")  # Load
```

Enjoy exploring Conway's Game of Life! 🎮
