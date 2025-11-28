"""
    GameOfLife

A Julia implementation of Conway's Game of Life cellular automaton.

This module provides a complete simulation engine with visualization capabilities,
predefined patterns, file I/O, and interactive controls.

# Main Components
- `Grid`: Data structure for the cellular grid
- `Simulation`: Simulation engine implementing Game of Life rules
- Pattern library with classic configurations
- Visualization using Plots.jl
- File I/O for saving and loading configurations
- Interactive mode with keyboard controls

# Example
```julia
using GameOfLife

# Create a grid and add a glider pattern
grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 10, 10)

# Run simulation
sim = Simulation(grid)
run_interactive(sim)
```
"""
module GameOfLife

# Include submodules
include("grid.jl")
include("patterns.jl")
include("simulation.jl")
include("visualization.jl")
include("fileio.jl")
include("interactive.jl")

# Export Grid type and functions
export Grid, set_cell!, get_cell, randomize!, clear!, copy_grid

# Export pattern functions
export get_pattern, place_pattern!

# Export Simulation type and functions
export Simulation, step!, run!, reset!, count_neighbors

# Export visualization functions
export visualize, create_animation, interactive_mode

# Export file I/O functions
export save_grid, load_grid, validate_file

# Export interactive functions
export run_interactive, adjust_speed, handle_command

end # module
