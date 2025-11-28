# Basic Usage Example for Game of Life
# This script demonstrates the fundamental features of the GameOfLife module

using Pkg
# Activate the project (assumes you're running from the project root)
Pkg.activate(".")

using GameOfLife

println("=" ^ 60)
println("Game of Life - Basic Usage Example")
println("=" ^ 60)

# Example 1: Create a grid and manually set cells
println("\n1. Creating a grid and setting individual cells...")
grid1 = Grid(30, 30)
set_cell!(grid1, 15, 15, true)
set_cell!(grid1, 15, 16, true)
set_cell!(grid1, 15, 17, true)
println("Created a 30x30 grid with 3 cells alive")

# Example 2: Create a grid with random initialization
println("\n2. Creating a grid with random initialization...")
grid2 = Grid(50, 50)
randomize!(grid2, 0.3)  # 30% of cells will be alive
println("Created a 50x50 grid with ~30% cells alive")

# Example 3: Using predefined patterns
println("\n3. Using predefined patterns...")
grid3 = Grid(50, 50)
glider = get_pattern(:glider)
place_pattern!(grid3, glider, 10, 10)
println("Placed a glider pattern at position (10, 10)")

# Example 4: Running a simulation
println("\n4. Running a simulation...")
sim = Simulation(grid3)
println("Initial generation: $(sim.generation)")

# Advance by single steps
step!(sim)
println("After 1 step: generation $(sim.generation)")

# Run multiple generations
run!(sim, 9)
println("After running 9 more steps: generation $(sim.generation)")

# Example 5: Visualizing the simulation
println("\n5. Creating visualization...")
p = visualize(sim.current_grid, generation=sim.generation)
display(p)
println("Visualization displayed")

# Example 6: Resetting the simulation
println("\n6. Resetting simulation...")
reset!(sim)
println("Reset to generation: $(sim.generation)")

# Example 7: Saving and loading grids
println("\n7. Saving and loading grids...")
save_grid(grid3, "example_pattern.txt")
loaded_grid = load_grid("example_pattern.txt")
println("Grid saved and loaded successfully")

# Example 8: Creating an animation (optional - takes time)
println("\n8. Creating animation (optional)...")
println("Uncomment the following lines to create a GIF animation:")
println("# grid_anim = Grid(50, 50)")
println("# place_pattern!(grid_anim, get_pattern(:glider), 10, 10)")
println("# sim_anim = Simulation(grid_anim)")
println("# create_animation(sim_anim, 50, 10, filename=\"glider_demo.gif\")")

# Example 9: Interactive mode
println("\n9. Interactive mode...")
println("To run in interactive mode, use:")
println("  run_interactive(sim, fps=10, auto_start=true)")
println("Or for manual control:")
println("  run_interactive(sim)")

println("\n" ^ 60)
println("Basic usage examples complete!")
println("Try experimenting with different patterns and grid sizes.")
println("=" ^ 60)
