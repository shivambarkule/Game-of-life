#!/usr/bin/env julia

# Simple Demo Script for Game of Life
# This creates a glider pattern and runs it for a few generations

using Pkg
Pkg.activate(".")

println("Loading GameOfLife module...")
using GameOfLife

println("\n" * "="^60)
println("Conway's Game of Life - Julia Implementation")
println("="^60)

# Create a grid
println("\n1. Creating a 50x50 grid...")
grid = Grid(50, 50)

# Add a glider pattern
println("2. Placing a glider pattern at position (20, 20)...")
place_pattern!(grid, get_pattern(:glider), 20, 20)

# Create simulation
println("3. Creating simulation...")
sim = Simulation(grid)

# Show initial state
println("4. Visualizing initial state (Generation 0)...")
p = visualize(sim.current_grid, generation=sim.generation)
display(p)

println("\nPress Enter to advance through generations (or Ctrl+C to quit)...")
readline()

# Run for a few generations with visualization
for i in 1:10
    step!(sim)
    println("\nGeneration $(sim.generation)")
    p = visualize(sim.current_grid, generation=sim.generation)
    display(p)
    
    if i < 10
        println("Press Enter for next generation...")
        readline()
    end
end

println("\n" * "="^60)
println("Demo complete!")
println("\nTry these commands in Julia REPL:")
println("  using GameOfLife")
println("  grid = Grid(50, 50)")
println("  randomize!(grid, 0.3)")
println("  sim = Simulation(grid)")
println("  run_interactive(sim, fps=10, auto_start=true)")
println("="^60)
